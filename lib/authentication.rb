module Authentication
  #Permisos por roles
  # Filtramos algunos porque el AS pasa de sus métodos 'accion_authorized?'
  def self.included(base)
    model = base.controller_name.singularize.camelize.constantize rescue nil
    return if !model || !model.table_exists?
    (base.active_scaffold_config_for(model).actions.map {|a| a}+base.active_scaffold_config_for(model).action_links.map {|al| al.action}).each do |accion|
      #if !['list', 'index', 'new', 'edit', 'delete'].include?(accion.to_s)
        class_eval <<-EOC
          def #{accion.to_s}_authorized?
            return current_user.tiene_permiso_para?("#{accion.to_s}_#{base.controller_name}")
          end
        EOC
      #end
    end
  end
 
  # Los otros los tratamos con un before_filter
  def access_authorized?
    return true if params[:controller] == "usuarios" && ['login', 'logout'].include?(params[:action])
    if ['list', 'index', 'new', 'edit', 'delete'].include?(params[:action].to_s) && !current_user.tiene_permiso_para?("#{params[:action].to_s}_#{self.controller_name}")
      flash[:error] = "No tiene permisos para acceder al recurso solicitado (#{params[:controller]}->#{params[:action]})"
      STDERR.puts "El usuario #{session[:user][:login]} no tiene permisos para acceder al recurso solicitado (#{params[:controller]}->#{params[:action]})"
      redirect_to request.referer || url_for(session[:user][:default_menu_option])
    end
  end
end
