
# Durante el desarrollo utilizaremos handlers de mongrel
# para servir ficheros estáticos de los plugins

require 'desert_public_files'

(proc {

    # TODO Buscar una manera mejor de hacer esto

    mongrel_prefix = nil
    mongrel = nil

    if defined?(Mongrel)
        ObjectSpace.each_object(Mongrel::Rails::RailsConfigurator) {|o| mongrel_prefix = o.defaults[:prefix] }
        ObjectSpace.each_object(Mongrel::HttpServer) { |o| mongrel = o }
    end

    # Añadimos una ruta bajo $prefix/public_PLUGIN/ para los ficheros estáticos
    # de los plugins
    Desert::Manager.plugins.each {|plugin|
        plugin_public_path = File.join(plugin.path, "public")
        if File.directory?(plugin_public_path)
            plugin_root = "#{mongrel_prefix}/public_#{plugin.name}"
            Desert::PublicFiles.register plugin_root, plugin_public_path
            if mongrel
                mongrel.register(plugin_root, Mongrel::DirHandler.new(plugin_public_path, false))
            end
        end

    }

    # Añadimos el public/ del raíz en el último lugar
    Desert::PublicFiles.register "", "#{RAILS_ROOT}/public"

}).call


# Usamos rewrite_asset_path para manipular las URLS de los ficheros
# estáticos. De esta manera apenas tenemos que manipular el funcionamiento
# interno de ActionView
ActionView::Helpers::AssetTagHelper.class_eval do 
    def rewrite_asset_path(source)
        Desert::PublicFiles.find_file source
    end
end

