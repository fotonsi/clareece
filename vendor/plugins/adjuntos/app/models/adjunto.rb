class Adjunto < ActiveRecord::Base
  belongs_to :parent, :polymorphic => true
  has_attachment :storage => :file_system, :path_prefix => 'public/adjuntos', :partition => false

  def full_filename(thumbnail = nil)
    File.join(RAILS_ROOT, *file_system_path)
  end
 
  # Ruta interna de cada fichero.
  def file_system_path
    path_prefix = (thumbnail ? thumbnail_class : self).attachment_options[:path_prefix].to_s
    [path_prefix, self.parent_type.underscore, attachment_path_id.to_s, self.id.to_s] + partitioned_path(thumbnail_name_for(thumbnail))
  end

end
