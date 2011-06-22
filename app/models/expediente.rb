class Expediente < ActiveRecord::Base
  has_one :colegiado, :dependent => :nullify
  has_many :expedientes_gestiones, :dependent => :destroy
  has_many :gestiones_documentales, :through => :expedientes_gestiones 
  has_many :notas, :as => :origen, :dependent => :destroy, :order => 'id'
  has_and_belongs_to_many :expedientes, :association_foreign_key => 'expediente_relacion_id', :order => 'id'

  TIPOS = TIPOS_EXPEDIENTES

  def to_label
    out = "Expediente"
    out += " Nº #{id}" unless new_record?
    out += " (#{colegiado.to_label})" if colegiado
    out += " (#{titulo})" unless colegiado
    return out
  end

  # Tipos
  TIPOS.each do |tipo|
    class_eval <<-EOC
      def tipo_#{tipo}?
        tipo == "#{tipo}"
      end
    EOC
  end


  # Expedientes que tiene relacionados o viceversa.
  def expedientes_relacionados
    Expediente.find(:all, :conditions => %|id in (select expediente_relacion_id from expedientes_expedientes where expediente_id = #{id}) or 
                                           id in (select expediente_id from expedientes_expedientes where expediente_relacion_id = #{id})|)
  end

  def expediente_relacionado_ids
    expedientes_relacionados.map{|i| i.id}
  end

  def tiene_doc?(etiqueta)
    etiqs_docs_expediente.include?(etiqueta.to_sym)
  end

  def de
    #TODO hacerlo con una relación polimórfica. Ahora mismo colegiado tiene la clave externa
    (tipo == OBJETO_PRINCIPAL ? 'colegiado' : tipo).to_s.titleize.constantize.find_by_expediente_id(self.id) rescue nil
  end

  def etiquetas_obligatorias(todas = false)
    self.de.respond_to?('etiquetas_obligatorias') ? self.de.etiquetas_obligatorias(todas) : []
  end

  def etiquetas_optativas(todas = false)
    self.de.respond_to?('etiquetas_optativas') ? self.de.etiquetas_optativas(todas) : []
  end

  def etiqs_docs_expediente
    gestiones_documentales.map {|gd| gd.documento && gd.documento.tag_counts.map {|t| t.name.to_sym}}.compact.flatten
  end

  def documentos_que_faltan
    self.etiquetas_obligatorias.select {|e| !tiene_doc?(e.to_s)}
  end

  def completo?
    self.documentos_que_faltan.empty?
  end



  # messages

  def warning_messages
    messages = []
    return messages if self.new_record?

    messages << "Documentación del expediente incompleta, falta: #{self.documentos_que_faltan.map {|d| d.to_s.humanize}.join(', ')}" if !self.completo? && self.errors.empty?

    return messages
  end


  # authorized

  def authorized_for_destroy?
    colegiado.nil?
  end
 
  def importar_docs_archivo
    num_colegiado = colegiado.num_colegiado
    Dir.foreach("#{DIR_ARCHIVO_DOCS}/E#{num_colegiado}") do |f|
      next unless NOMBRES_FICHEROS.keys.include?(f)
      GestionDocumental.transaction do
        gd = GestionDocumental.create(:tipo => 'entrada', :remitente => 'Archivo escaneado', :destinatario => 'Colegio')
        str = File.open("#{DIR_ARCHIVO_DOCS}/E#{num_colegiado}/#{f}", "r").read rescue nil
        if str
          d = Documento.create
          nombre_dir = "#{Documento.attachment_options[:path_prefix]}/#{d.id}"
          Dir.mkdir(nombre_dir) if !File.exists? nombre_dir
          #d.content_type = 'application/msword'
          d.content_type = case File.extname(f)
            when 'pdf'
              'application/pdf'
            when 'jpg'
              'image/jpg'
            when 'png'
              'image/png'
          end
          d.filename = f
          g = File.open("#{nombre_dir}/#{d.filename}", "w")
          g.write str
          g.close
          d.size = str.to_s.size
          d.save
          if gd
            gd.documento = d
            gd.expedientes << self
            ege = ExpedienteGestionEtiqueta.new(:etiqueta => NOMBRES_FICHEROS[f].to_s)
            gd.expedientes_gestiones.first.etiquetas << ege
            gd.save
          end
        end
      end
    end
  end
end
