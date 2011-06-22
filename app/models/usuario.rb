class Usuario < ActiveRecord::Base
  require 'digest/sha1'

  has_and_belongs_to_many :roles
  belongs_to :origen, :polymorphic => true


  def self.current
    Thread.current[:current_user]
  end

  def self.current=(usuario)
    Thread.current[:current_user] = usuario
  end

  def self.logged_in?
    !!current
  end

  def to_label
    self.nombre_completo
  end

  def nombre_completo
    [self.nombre, self.apellido1, self.apellido2].join(" ")
  end

  def menu_options
    menu = []
    Menu::MenuOptions::TOTAL.each do |option|
      # Se quitan acciones para las que no tiene permiso
      submenu = option[:submenu].reject do |suboption|
        if not suboption[:url].empty?
          action = (suboption[:url][:action] || 'index') + "_" + suboption[:url][:controller]
          not self.tiene_permiso_para?(action)
        else
          false
        end
      end
      # Se añade la opción al menú si tiene permiso para alguna de sus acciones
      if not submenu.all?{|i| i[:url].empty?}
        opt = option
        opt[:submenu] = submenu
        menu << opt
      end
    end
    # Se evita que sea vacía la primera acción de cada opción del menú
    menu.each_with_index do |option, index|
      first = 0
      menu[index][:submenu].each do |option|
        break if not option[:url].blank?
        first += 1
      end
      menu[index][:submenu] = menu[index][:submenu][first..-1]
    end

    return menu
  end

  def default_menu_option
    menu_options[0][:submenu][0][:url]
  end

  def self.google_apps_login(login, password, captcha_token, captcha_answer)
    begin
      return Google.login(login, password, captcha_token, captcha_answer)
    rescue Exception => e
      if e.kind_of?(GData::Client::CaptchaError)
        return {:login => login, :captcha_url => "#{GAPPS_CAPTCHA_URL}/#{e.url}", :captcha_token => e.token, :notice => "Para su mayor seguridad introduzca debajo de la imagen lo que aparece escrito en ella."}
      elsif e.kind_of?(GData::Client::AuthorizationError)
        return {:error => "El usuario o la contraseña son incorrectos."}
      end
    end
  end

  def tiene_permiso_para?(nombre, params_id = nil)
    #Miramos si la lista de permisos de este rol contiene el nombre de la acción que nos pasan
    # (si empieza por list lo cambiamos por index para sólo tener que dar de alta uno de los dos permisos)
    #TODO Hacer mejor el permiso de edición para dejar sólo acceso a la ficha del usuario.
    permisos = self.roles.map {|r| r.permisos.map {|per| per.nombre} }.flatten
    permisos.include?(nombre.gsub('list', 'index'))
  end

  def self.encrypt(password)
    Digest::SHA1.hexdigest(password)
  end

  def caja
    u = ubicacion
    return Caja.find_by_ubicacion(u) if u
  end

  def ubicacion
    return 10011 if self.login == "admin"
    # TODO Generalizar ubicación sin LDAP
  end
end
