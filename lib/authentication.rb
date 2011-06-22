module Authentication
  #Permisos por roles
  # Filtramos algunos porque el AS pasa de sus métodos 'accion_authorized?'
#  def self.included(base)
#    model = base.controller_name.singularize.camelize.constantize rescue nil
#    return if !model || !model.table_exists?
#    (base.active_scaffold_config_for(model).actions.map {|a| a}+base.active_scaffold_config_for(model).action_links.map {|al| al.action}).each do |accion|
#      if !['list', 'index', 'new', 'edit', 'delete'].include?(accion.to_s)
#        class_eval <<-EOC
#          def #{accion.to_s}_authorized?
#            return current_user.tiene_permiso_para?("#{accion.to_s}_#{base.controller_name}")
#          end
#        EOC
#      end
#    end
#  end
 
  # Los otros los tratamos con un before_filter
  def access_authorized?
    return true if params[:controller] == "usuarios" && ['login', 'logout'].include?(params[:action])
    result = false
    #Hacer de otra forma el acceso granular a sólo datos relacionados con el usuario (no con permiso mis datos y mirando luego el edit para cada caso.)
    result =  if current_user.tiene_permiso_para?("#{params[:action].to_s}_#{self.controller_name}")
                true
              elsif self.respond_to?("#{params[:action]}_authorized?") #Si tiene método ya lo comprobará el AS
                true
              elsif params[:action] == 'show_search'
                true
              elsif params[:action] =~ /crear_existente/ && current_user.tiene_permiso_para?("new_#{params[:controller]}")
                true
              elsif params[:action] =~ /(.*)_associated/ && current_user.tiene_permiso_para?("#{$1}_#{params[:controller]}")
                true
              elsif params[:action] == 'row' && current_user.tiene_permiso_para?("index_#{params[:associations]}")
                true
              elsif params[:action] == 'nested' && params[:associations] && current_user.tiene_permiso_para?("index_#{params[:associations]}")
                true
              elsif params[:nested] && params[:controller] && current_user.tiene_permiso_para?("index_#{params[:controller]}")
                true
              elsif params[:action] == 'update_table' && current_user.tiene_permiso_para?("index_#{params[:controller]}")
                true
              elsif params[:action] == 'create' && current_user.tiene_permiso_para?("new_#{params[:controller]}")
                true
              elsif params[:action] == 'update' && current_user.tiene_permiso_para?("edit_#{params[:controller]}")
                true
              #Esto siempre lo llama desde el AS empotrado pero sin id, por lo que dejamos pasar pero reducimos las posibilidades de que nos manden la url a mano
              elsif params[:action] == 'table' && (params[:embedded] || params[:nested]) && request.referrer
                true
              elsif params[:action] =~ /^listar_(.*)/ && (current_user.tiene_permiso_para?("index_#{$1}") || (current_user.tiene_permiso_para?("mis_datos_colegiados") && params[:id].to_i == current_user.origen_id))
                true
              elsif params[:action] =~ /autocomplete_results/
                true
              elsif params[:action] == 'edit' && current_user.tiene_permiso_para?("mis_datos_colegiados")
                case params[:controller]
                when 'colegiados'
                  true if params[:id].to_i == current_user.origen_id
                when 'expedientes'
                  col = Colegiado.find_by_expediente_id(params[:id])
                  true if col.id == current_user.origen_id
                end
              end

    if !result
      flash[:error] = "No tiene permisos para acceder al recurso solicitado (#{params[:controller]}->#{params[:action]})"
      STDERR.puts "El usuario #{session[:user][:login]} no tiene permisos para acceder al recurso solicitado (#{params[:controller]}->#{params[:action]})"
      redirect_to request.referer || url_for(session[:user][:default_menu_option])
    end
  end
end
