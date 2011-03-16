include ActionView::Helpers::NumberHelper
require 'export_utils'
require 'open3'


## Creamos una clase para poder dibujar rectÃ¡ngulos vacÃ­os dentro del cÃ³digo
#  usando <C:rect />

module PDF
    
    def PDF.aplicar_fondo (pdfstring, fichero_fondo)

        fds = Open3.popen3("pdftk", "-", "background", fichero_fondo, "output", "-")
        fds[2].close
        fds[0].write(pdfstring)
        fds[0].close
        pdfstring = fds[1].read
        fds[1].close

        return pdfstring
    end

    def PDF.crearFDF(pdf, instancia)
      data = "%FDF-1.2\x0d%\xe2\xe3\xcf\xd3\x0d\x0a"; # header
      data += "1 0 obj\x0d<< " # open the Root dictionary
      data += "\x0d/FDF << " # open the FDF dictionary
      data += "/Fields [ " # open the form Fields array

      campos = Array.new
      IO.foreach(pdf) do |linea|
        if linea =~ /\/T ?\((\w+)\)/
          campos << $1
        end
      end

      campos.each do |campo|
        #STDERR.puts campo
        valor = ExportUtils::value2text(instancia.send(campo) || "") rescue campo
        valor = Iconv.new('iso-8859-15', 'utf-8').iconv(valor) if valor.is_utf8?

        data += '<< /T (' + campo + ') /V (' + valor + ') /ClrF 2 /ClrFf 1 >> '
      end
      
      data += "] \x0d" # close the Fields array
      data += ">> \x0d" # close the FDF dictionary
      data += ">> \x0dendobj\x0d" # close the Root dictionary

      data += "trailer\x0d<<\x0d/Root 1 0 R \x0d\x0d>>\x0d" 
      data += "%%EOF\x0d\x0a" 
      data
    end

    def PDF.rellenar (pdf, instancia)
      fds = Open3.popen3("pdftk", pdf, "fill_form", "-", "output", "-", "flatten")
      fds[2].close
      fds[0].write(PDF::crearFDF(pdf, instancia))
      fds[0].close
      pdfstring = fds[1].read
      fds[1].close

      STDERR.puts "El resultado de la plantilla ha salido vacío, revise si hay algún paréntesis sin cerrar o algo así en algún campo" if pdfstring.empty?
      return pdfstring
    end
end
