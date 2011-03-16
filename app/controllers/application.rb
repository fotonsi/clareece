# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  #helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  #protect_from_forgery # :secret => '817a2f225b30d48a4f36a2d4b94ab7ef'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  #def pick_layout(*args)
  #  "layouts/application"
  #end 
  
  # Scrub sensitive parameters from your log
  filter_parameter_logging :password

  include MenuOptions

  # Necesitamos guardar el controlador para poder generar traducciones propias de cada controlador.
  before_filter :save_controller
  before_filter :usuario_valido, :except => 'login'

  audit Colegiado, GestionDocumental, Expediente, Transaccion, Remesa, Movimiento, :only => [:create, :update, :destroy]

  def save_controller
    Thread.current[:controller] = params[:controller]
  end

  def usuario_valido
    session[:user] ||= {}
    if not current_user
      #session[:user][:request] = request.request_uri
      redirect_to :controller => 'usuarios', :action => 'login'
    else 
      Thread.current[:current_user] = current_user
    end
  end

  def current_user
    session[:user][:login].blank? ? nil : Usuario.find_by_login(session[:user][:login])
  end

  ActiveScaffold.set_defaults do |config|
    config.update.link.icon = {:image => "actions/modificar.gif", :title => "#{as_('edit')}"}
    config.delete.link.icon = {:image => "actions/borrar.gif", :title => "#{as_('delete')}"}
    config.show.link.icon = {:image => "actions/ver.gif", :title => "#{as_('show')}"}
    config.list.per_page = 25
  end

  def render_json(json, options={})
    callback, variable = params[:callback], params[:variable]
    response = begin
      if callback && variable
        "var #{variable} = #{json};\n#{callback}(#{variable});"
      elsif variable
        "var #{variable} = #{json};"
      elsif callback
        "#{callback}(#{json});"
      else
        json
      end
    end
    render({:content_type => :js, :text => response}.merge(options))
  end

  #Métodos para autocompletado
  include FieldSearch
  def colegiado_autocomplete_results
    cols = if params[:term].blank?
             []
           elsif params[:term] =~ /#\d+$/
             Colegiado.find_all_by_num_colegiado(params[:term][1..-1])
           else
             Colegiado.find(:all, :conditions => ApplicationController.conditions_for_text(params[:term], %w(nombre apellido1 apellido2 doc_identidad)))
           end
    cols = {:records => cols.map {|col| {:to_label => (col.respond_to?('to_autocomplete_label') ? col.to_autocomplete_label : col.to_label), :ID => col.id}}}
    render_json cols.to_json
  end

  def localidad_autocomplete_results
    cols = if params[:term].blank?
             []
           elsif params[:term] =~ /#\d+$/
             Localidad.find_all_by_cp(params[:term][1..-1])
           else
             Localidad.find(:all, :conditions => ApplicationController.conditions_for_text(params[:term], %w(cp nombre)))
           end
    cols = {:records => cols.map {|col| {:to_label => (col.respond_to?('to_autocomplete_label') ? col.to_autocomplete_label : col.to_label), :id => col.id}}}
    render_json cols.to_json
  end

  def gestion_documental_autocomplete_results
    cols = if params[:term].blank?
             []
           elsif params[:term] =~ /#\d+$/
             GestionDocumental.find_all_by_num_registro(params[:term][1..-1], :order => 'created_at DESC')
           else
             GestionDocumental.find(:all, :conditions => ApplicationController.conditions_for_text(params[:term], %w(num_registro tipo destinatario remitente texto observaciones)))
           end
    cols = {:records => cols.map {|col| {:to_label => (col.respond_to?('to_autocomplete_label') ? col.to_autocomplete_label : col.to_label), :id => col.id}}}
    render_json cols.to_json
  end

  def expediente_autocomplete_results
    cols = if params[:term].blank?
             []
           elsif params[:term] =~ /#\d+$/
             Expediente.find_all_by_id(params[:term][1..-1])
           else
             Expediente.find(:all, :conditions => ApplicationController.conditions_for_text(params[:term], %w(titulo tipo)))
           end
    cols = {:records => cols.map {|col| {:to_label => (col.respond_to?('to_autocomplete_label') ? col.to_autocomplete_label : col.to_label), :id => col.id}}}
    render_json cols.to_json
  end

  include AfterSaveHandlers
end
