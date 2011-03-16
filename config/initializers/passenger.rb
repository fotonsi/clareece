

# Definiciones para Passenger
if defined?(PhusionPassenger)

    # Creamos los enlaces simbólicos para public/public_FOO

    Desert::Manager.plugins.each do |plugin|
        plugin_public_path = File.join(plugin.path, "public")

        if File.directory?(plugin_public_path)
            web_path = File.join(Rails.root, "public/public_#{plugin.name}")
            if File.symlink?(web_path) and File.readlink(web_path) == plugin_public_path
                next
            elsif File.exist?(web_path)
                STDERR.puts "Removing #{web_path}"
                File.unlink(web_path)
            end

            STDERR.puts "Creating #{web_path}"
            File.symlink(plugin_public_path, web_path)
        end
    end

end
