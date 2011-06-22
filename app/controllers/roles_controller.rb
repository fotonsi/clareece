class RolesController < ApplicationController
  include Authentication
  before_filter :access_authorized?
  active_scaffold :rol do |config|
    config.list.columns = [:descripcion, :permisos, :usuarios]
    config.create.columns.exclude :usuarios
    config.update.columns.exclude :usuarios
    config.action_links.add 'importar_usuarios_ldap',
	:label => 'Importar usuarios LDAP',
        :icon => {:image => "shared/personas.png", :title => 'Importa los usuarios de este grupo desde el LDAP'},
	:controller => 'roles',
	:action => 'importar_usuarios_ldap',
	:type => :record,
	:security_method => 'puede_importar_ldap?',
	:crud_type => :update,
	:position => :after,
	:inline => true
  end if Rol.table_exists?

  def puede_importar_ldap?
    true
  end

  def importar_usuarios_ldap
    begin
      Rol.find(params[:id]).importar_usuarios_ldap
    rescue Exception => e
      raise e
    end
  end
end
