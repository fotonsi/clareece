class Documento < ActiveRecord::Base
  has_attachment :storage => :file_system, :path_prefix => 'public/documentos', :partition => false
  has_many :gestiones_documentales, :class_name => "GestionDocumental", :dependent => :nullify, :order => 'id'

  acts_as_taggable

  def full_filename(thumbnail = nil)
    File.join(RAILS_ROOT, *file_system_path(thumbnail).compact)
  end
 
  # Ruta interna de cada fichero.
  def file_system_path(thumbnail = nil)
    path_prefix = (thumbnail ? thumbnail_class : self).attachment_options[:path_prefix].to_s
    [path_prefix, attachment_path_id.to_s] + partitioned_path(thumbnail_name_for(thumbnail))
  end

end
