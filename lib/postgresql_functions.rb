
# Adaptado de http://rubyforge.org/projects/railspgprocs/

require 'active_record/schema_dumper'
ActiveRecord::SchemaDumper.class_eval do

    def get_pgsql_type(types)
        case types
        when Array
            types.collect {|type|
                get_pgsql_type(type)
            }.join(", ")
        when String && /^\d+$/
            type = @connection.select_value("SELECT typname FROM pg_type WHERE oid = '#{types}'")
            return type = 'nil' if type == 'void'
            get_pgsql_type(type)
        when String
            types.to_sym.inspect
        end
    end

    # TODO - Facilitate create_proc(name, [argname, argtype] and create_proc(name, [argmode, argname, argtype] ...
    def procedures(stream, conditions=nil)
        @connection.procedures(conditions).each { |proc_row|
            oid, name, namespace, owner, lang, is_agg, sec_def, is_strict, ret_set, volatile, nargs, ret_type, arg_types, arg_names, src, bin, acl = proc_row
            is_agg    = is_agg    == 't'
            is_strict = is_strict == 't'
            ret_set   = ret_set   == 't'
            arg_names ||= ''
            args      = get_pgsql_type(arg_types.split(" "))#.zip(arg_names.split(" "))

            stream.print "  create_proc(#{name.to_sql_name}, [#{args}], :return => #{get_pgsql_type(ret_type)}"
            stream.print ", :resource => ['#{bin}', '#{src}']" unless bin == '-'
            stream.print ", :set => true" if ret_set
            stream.print ", :strict => true" if is_strict
            stream.print ", :behavior => '#{pg_behavior(volatile)}'" unless volatile == 'v'
            stream.print ", :lang => '#{lang}')"
            stream.print " {\n    <<-#{name.underscore}_sql\n#{src.chomp}\n    #{name.underscore}_sql\n  }" if bin == '-'
            stream.print "\n\n"
        }
    end

    def tables_with_postgresql_functions(stream)
        procedures(stream, "!= 'sql'")
        tables_without_postgresql_functions(stream)
        procedures(stream, "= 'sql'")
        stream
    end

    alias_method_chain :tables, :postgresql_functions

end


# Modificaciones a PostgreSQLAdapter

require 'active_record/connection_adapters/postgresql_adapter'
module PostgreSQLAdapterWithFunctions
    def procedures(lang=nil)
        query <<-end_sql
          SELECT P.oid, proname, pronamespace, proowner, lanname, proisagg, prosecdef, proisstrict, proretset, provolatile, pronargs, prorettype, proargtypes, proargnames, prosrc, probin, proacl
            FROM pg_proc P
            JOIN pg_language L ON (P.prolang = L.oid)
            JOIN pg_namespace N ON (P.pronamespace = N.oid)
           WHERE N.nspname = 'public'
             AND (proisagg = 'f')
            #{'AND (lanname ' + lang + ')'unless lang.nil?}
        end_sql
    end


    #      Create a stored procedure
    def create_proc(name, columns=[], options={}, &block)
        if select_value("SELECT count(oid) FROM pg_language WHERE lanname = 'plpgsql' ","count").to_i == 0
            execute("CREATE FUNCTION plpgsql_call_handler() RETURNS language_handler AS '$libdir/plpgsql', 'plpgsql_call_handler' LANGUAGE c")
            execute("CREATE TRUSTED PROCEDURAL LANGUAGE plpgsql HANDLER plpgsql_call_handler")
        end

        if options[:force]
            drop_proc(name, columns) rescue nil
        end

        if block_given?
            execute get_proc_query(name, columns, options) { yield }
        elsif options[:resource]
            execute get_proc_query(name, columns, options)
        else
            raise StatementInvalid.new("Missing function source")
        end
    end

    #      DROP FUNCTION name ( [ type [, ...] ] ) [ CASCADE | RESTRICT ]
    #     default RESTRICT
    def drop_proc(name, columns=[], cascade=false)
        execute "DROP FUNCTION #{name.to_sql_name}(#{columns.collect {|column| column}.join(", ")}) #{cascade_or_restrict(cascade)};"
    end


    #       From PostgreSQL
    ##      CREATE [ OR REPLACE ] FUNCTION
    ##          name ( [ [ argmode ] [ argname ] argtype [, ...] ] )
    ##          [ RETURNS rettype ]
    ##        { LANGUAGE langname
    ##          | IMMUTABLE | STABLE | VOLATILE
    ##          | CALLED ON NULL INPUT | RETURNS NULL ON NULL INPUT | STRICT
    #          | [ EXTERNAL ] SECURITY INVOKER | [ EXTERNAL ] SECURITY DEFINER
    ##          | AS 'definition'
    #          | AS 'obj_file', 'link_symbol'
    #        } ...
    #          [ WITH ( isStrict &| isCacheable ) ]
    # TODO Implement [ [ argmode ] [ argname ] argtype ]
    def get_proc_query(name, columns=[], options={}, &block)
        returns = "RETURNS#{' SETOF' if options[:set]} #{options[:return] || 'VOID'}"
        lang = options[:lang] || "plpgsql"

        if block_given?
            delim = proc {|name, options|
                        name = name.split('.').last if name.is_a?(String) && name.include?('.')
                        options[:delim] || "$#{name.underscore}_body$"
            }
            body = "#{delim.call(name, options)}\n#{yield}\n#{delim.call(name, options)}"
        elsif options[:resource]
            options[:resource] += [name] if options[:resource].size == 1
            body = options[:resource].collect {|res| "'#{res}'" }.join(", ")
        else
            raise StatementInvalid.new("Missing function source")
        end

        result = "
                  CREATE OR REPLACE FUNCTION #{name.to_sql_name}(#{columns.collect{|column| column}.join(", ")}) #{returns} AS
                        #{body}
                        LANGUAGE #{lang}
                        #{ pg_behavior(options[:behavior] || 'v').upcase }
                        #{ strict_or_null(options[:strict]) }
                        EXTERNAL SECURITY #{ definer_or_invoker(options[:definer]) }
        "
    end

    def pg_behavior(volatile='v')
        %w{immutable stable volatile}.grep(/^#{volatile[0,1]}.+/).to_s
    end

    def strict_or_null(strict = false)
        strict ? 'STRICT' : 'CALLED ON NULL INPUT' 
    end

    def definer_or_invoker(definer=false)
        definer ? 'DEFINER' : 'INVOKER'
    end

    def cascade_or_restrict(cascade=false)
        cascade ? 'CASCADE' : 'RESTRICT'
    end

end

class String
    def to_sql_name
        %("#{inspect[1..-2]}")
    end
end


# Includes
ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.send :include, PostgreSQLAdapterWithFunctions
