class DocumentosController < ApplicationController
  include Authentication
  before_filter :access_authorized?

  active_scaffold :documento do |config|
    config.list.columns = [:id, :filename, :size, :content_type, :tag_list]
    config.actions.exclude :create
    config.columns.add :tag_list
    config.update.link.inline = true
    config.update.columns = [:tag_list]
  end if Documento.table_exists?

  def return_to_main
    redirect_to({'action' => 'edit', 'id' => @record}.merge(active_scaffold_session_storage[:parent_url] || {})) 
  end

end
