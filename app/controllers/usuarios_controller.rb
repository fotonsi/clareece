class UsuariosController < ApplicationController
  
  include Authentication
  before_filter :access_authorized?

  active_scaffold :usuario do |config|
    config.list.columns = [:login, :nombre_completo, :roles]
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
          require 'md5'
          raise LoginError, "Invalid credentials" if user.password != MD5.new(params[:password]).to_s
        end
      rescue Exception => e
        if (e.class == LDAP::ResultError && e.message == 'Invalid credentials') || e.class == LoginError
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

end

class LoginError < Exception; end
