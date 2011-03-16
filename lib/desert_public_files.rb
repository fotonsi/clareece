
module Desert 

    # Este módulo guarda los directorios que contienen ficheros públicos
    # y las URLs donde se encuentran.
    module PublicFiles
        extend self

        attr_reader :items

        # Añade un directorio a la lista de rutas donde se buscarán
        # ficheros estáticos. Los primeros en añadir tienen más preferencia
        def register(url_root, path)
            @items ||= []
            @items << {:url_root => url_root, :path => path.chomp("/")}
        end

        # Recorre la lista de directorios estáticos para encontrar el fichero
        # que corresponde con la ruta solicitada. Si no encuentra ninguno devolverá
        # la ruta como si perteneciera al raíz
        def find_file(filename)
            filename = filename.gsub(/^\/*/, "/")

            @items.each {|item|
                abs_path = [item[:path], filename].join
                if File.exist?(abs_path)
                    return [item[:url_root], filename].join
                end
            }

            # Por omisión devolvemos el fichero tal cual
            filename
        end

    end

end
