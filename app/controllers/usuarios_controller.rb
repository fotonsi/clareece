class UsuariosController < ApplicationController
  
  include Authentication
  before_filter :access_authorized?

  active_scaffold :usuario do |config|
    config.list.columns = [:login, :nombre_completo, :roles]
    config.create.columns = [:nombre, :apellido1, :apellido2, :login, :password, :roles]
    config.update.columns = [:nombre, :apellido1, :apellido2, :login, :roles]
  end if Usuario.table_exists?

  def login
    if WORK_IN_LOCAL
      session[:user] ||= {:login => "admin"}
    else
      session[:user] ||= {}
    end
    if not session[:user][:login].blank?
      # Usuario logeado
      user = Usuario.find_by_login(session[:user][:login])
      flash[:error] = I18n.t("view.usuario.not_registered", :login => session[:user][:login]) if not user 
    elsif request.post?
      # Intentando logear
      begin
        user = Usuario.find_by_login(params[:login])
        if LDAP_LOGIN && user.origen_type == 'ldap'
          LdapUtil.login(params[:login], params[:password])
        else
          raise LoginError, "Invalid credentials" if !user || user.password != Usuario.encrypt(params[:password])
        end
      rescue Exception => e
        if (LDAP_LOGIN && e.class == LDAP::ResultError && e.message == 'Invalid credentials') || e.class == LoginError
          flash[:error] = "El usuario o la contraseña son incorrectos."
        else
          flash[:error] = "Error: #{e.message}"
        end
        redirect_to :action => 'login' 
        return
      end
      flash[:error] = I18n.t("view.usuario.not_registered", :login => params[:login]) if not user 
    end

    if user
      session[:user][:login] = user.login
      session[:user][:menu_options] = user.menu_options  
      session[:user][:default_menu_option] = user.default_menu_option
      redirect_to user.default_menu_option 
    end
  end

  def logout
    reset_session
    redirect_to :action => 'login'
  end

  def before_create_save(record)
    record.password = Usuario.encrypt(record.password)
  end

end

class LoginError < Exception; end
