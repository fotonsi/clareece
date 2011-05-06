class Informe < ActiveRecord::Base
  include REXML
  has_attachment :storage => :file_system, :path_prefix => 'public/informes', :partition => false

  MODELOS = [:colegiado, :expediente, :movimiento, :formacion, :caja_cuadre, :caja_cuadre_calculado, :libramiento, :recibo_cuota, :recibo_generico, :diploma, :curso_alumno]

  validates_presence_of :nombre, :objeto, :filename

  def validate
    errors.add('registro', 'Debe indicar si se requiere registro') if registro.nil?
  end

  def full_filename(thumbmail = nil)
    File.join(RAILS_ROOT, *file_system_path(thumbnail).compact)
  end

  def file_system_path(thumbnail = nil)
    path_prefix = (thumbnail ? thumbnail_class : self).attachment_options[:path_prefix].to_s
    [path_prefix, attachment_path_id.to_s] + partitioned_path(thumbnail_name_for(thumbnail))
  end

  def parsea(objeto, num_reg = nil)
    require "hpricot"
    
    file = File.new(self.full_filename)
    doc = Hpricot::XML file

    names = doc.search '//text:database-display'
    
    names.each do |name|
      obj = name.attributes['text:table-name'] == 'public.colegios' ? Colegio.first : objeto
      obj = objeto.connection.select_one("select * from #{name.attributes['text:table-name']} where id = #{objeto.id}") if name.attributes['text:table-name'].gsub('public.', '') != objeto.class.table_name
      name.inner_html = if obj.nil?
      			  "[#ERR: la tabla '#{name.attributes['text-table-name']}' especificada en el campo '#{name}' da lugar a un objeto nulo"
      			elsif obj.respond_to?(name.attributes['text:column-name'].downcase)
                          ExportUtils.value2text(obj.send(name.attributes['text:column-name'].downcase))
                        elsif obj.has_key?(name.attributes['text:column-name'].downcase)
                          obj[name.attributes['text:column-name'].downcase]
                        else
                          "[#ERR: no existe campo '#{name.attributes['text:column-name']}']"
                        end
    end

    #Insertamos el registro de E/S o título
    # (usar el campo establecer variable de openoffice)
    vars = doc.search '//text:variable-set'
    vars.each do |var|
      case var.attributes['text:name']
      when 'registro'
        var.inner_html = num_reg.to_s if num_reg
      end
    end
    return doc
  end

  def obtener_para(objeto)
    #Probar y revisar para títulos de cursos.
    nombre_fichero = Documento.new.sanitize_filename("#{self.nombre} #{self.objeto}_#{objeto.id}.fodt")
    GestionDocumental.transaction do
      gd = GestionDocumental.create(:tipo => 'salida', :remitente => 'Colegio', :destinatario => (objeto.respond_to?("to_label") ? objeto.to_label : 'informe generado')) if self.registro
      str = self.parsea(objeto, (gd.num_registro if gd))
      if str
        d = Documento.create
        nombre_dir = "#{Documento.attachment_options[:path_prefix]}/#{d.id}"
        Dir.mkdir(nombre_dir) if !File.exists? nombre_dir
        f = File.open("#{nombre_dir}/#{nombre_fichero}", "w")
        f.write str
        f.close
        d.content_type = 'application/msword'
        d.filename = nombre_fichero
        d.size = str.to_s.size
        d.save
        if gd
          gd.documento = d
          gd.expedientes << objeto.expediente if objeto.respond_to?('expediente')
          gd.save
        end
        return gd || d #Si retornamos gd es con registro sino el documento sólo
      end
    end
  end
end
