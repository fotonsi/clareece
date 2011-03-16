class GestionDocumental < ActiveRecord::Base
  belongs_to :documento
  has_many :expedientes_gestiones, :dependent => :destroy
  has_many :expedientes, :through => :expedientes_gestiones
  has_one :titulo

  TIPOS = [:entrada, :salida]

  before_create :default_values
  before_destroy :delete_documento
  
  def validate
    errors.add "remitente", "El remitente es obligatorio en entradas" if self.tipo == 'entrada' && !self.remitente
    errors.add "destinatario", "El remitente es obligatorio en salidas" if self.tipo == 'salida' && !self.destinatario
  end

  def default_values
    # Nombre del documento asociado
    self.nombre_documento = documento ? documento.filename : ""
    # Número de registro
    self.num_registro = GestionDocumental.find_by_sql("select nextval('registro_#{self.tipo}_seq') as sig_num_registro;").first['sig_num_registro']
  end

  def delete_documento
    documento.destroy if authorized_for_delete_documento? 
  end


  def to_label
    out = "Gestión documental#{" de "+tipo.titleize if tipo}#{" nº #{num_registro}" if num_registro}"
    return out
  end

  def to_autocomplete_label
    out = "nº #{num_registro} #{tipo.titleize}: #{tipo == 'salida' ? 'dest.'+destinatario : 'remit.'+remitente}, texto: #{texto}"
  end

  TIPOS.each do |tipo|
    class_eval <<-EOC
      def #{tipo}?
        tipo == "#{tipo}"
      end
    EOC
  end


  # Virtual methods

  def uploaded_data
    nil
  end

  def uploaded_data=(data)
    if not data.blank?
      delete_documento
      self.documento = Documento.new(:uploaded_data => data)
    end
  end


  # authorized

  def authorized_for_destroy?
    new_record? or expedientes_gestiones.empty?
  end

  def authorized_for_create_salida?
    entrada?
  end

  # Eliminar el documento sólo si no está asociado a otra gestión documental o a expedientes
  def authorized_for_delete_documento?
    documento and documento.gestiones_documentales.size == 1 #and documento.expedientes.empty?
  end

end
