
# Eliminamos las definiciones de db:schema:* y db:migrate para utilizar las nuestras
Rake::Task["db:schema:dump"].clear
Rake::Task["db:schema:load"].clear
Rake::Task["db:migrate"].clear

namespace :db do

    desc "Ejecuta las migraciones para la aplicación principal y los plugins cargados"
    task :migrate => :environment do

        require 'postgresql_functions'

        # Adaptado del db:migrate de Rails 2.2.2. No podemos llamarlo directamente a él porque
        # tenemos que ejecutar las migraciones de los plugins antes del db:schema:dump

        ActiveRecord::Migration.verbose = ENV["VERBOSE"] ? ENV["VERBOSE"] == "true" : true

        # Guardamos las actuales subclases de ActiveRecord::Migration para
        # eliminar las que se creen antes de cada plugin
        migrations_subclasses = ActiveRecord::Migration.subclasses.dup

        database_version = ENV["VERSION"] ? ENV["VERSION"].to_i : nil

        # Migraciones de los plugins
        Desert::Manager.plugins.each {|plugin|

            # Borramos las subclases nuevas
            (ActiveRecord::Migration.subclasses - migrations_subclasses).each {|cls|
                Object.send :remove_const, cls
            }

            puts "[PLUGIN] #{plugin.name}" if ActiveRecord::Migration.verbose
            Desert::PluginMigrations::Migrator.migrate_plugin plugin, database_version
        }

        puts "[ROOT]" if ActiveRecord::Migration.verbose
        ActiveRecord::Migrator.migrate("db/migrate/", database_version)

        # Generar el schema.rb
        Rake::Task["db:schema:dump"].invoke if ActiveRecord::Base.schema_format == :ruby
    end

    namespace :schema do
        desc "Create a db/schema.rb file that can be portably used against any DB supported by AR"
        task :dump => :environment do
            # Lógica para incluir procedimientos almacenados en los volcados
            require 'postgresql_functions'

            File.open(ENV['SCHEMA'] || "#{RAILS_ROOT}/db/schema.rb", "w") do |file|
                ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, file)
            end
        end

        desc "Load a schema.rb file into the database"
        task :load => :environment do
            require 'postgresql_functions'
            file = ENV['SCHEMA'] || "#{RAILS_ROOT}/db/schema.rb"
            load(file)

        end
    end

end

