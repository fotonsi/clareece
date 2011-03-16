ActiveRecord::ConnectionAdapters::SchemaStatements.module_eval do
  def initialize_schema_migrations_table_with_plugins
    initialize_schema_migrations_table_without_plugins

    table_name = Desert::PluginMigrations::Migrator.schema_migrations_table_name
    unless table_exists?(table_name)
      create_table table_name do |t|
        t.string :plugin_name
        t.string :version
      end
    end
  end

  alias_method_chain :initialize_schema_migrations_table, :plugins
end
