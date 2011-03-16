module AfterSaveHandlers

  def after_update_save(record)
    local_after_update_save(record) if respond_to?(:local_after_update_save)
    _go_to_index record
  end

  def after_create_save(record)
    local_after_create_save(record) if respond_to?(:local_after_create_save)
    if params[:after_create_handler]
      flash.discard
      render :file => 'common/after_create_handler'
    else
      _go_to_index record
    end
  end

  def _go_to_index(record)
    if active_scaffold_config_for(record.class).send(params[:action]).link.inline?
      return
    elsif respond_to?(:redirect_after_save)
      redirect_after_save(record.id)
    elsif params[:mode] == "dialog"
      render :file => 'common/close_crud_form'
    else
      redirect_to :action => :index
    end
  end

end
