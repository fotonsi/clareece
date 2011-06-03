class InformesController < ApplicationController
  include Authentication
  before_filter :access_authorized?
  active_scaffold :informe do |config|
    config.label = :label
    config.actions.exclude :show
    config.columns.add :uploaded_data
    config.columns[:registro].label = "Req. registro"

    #List
    config.list.columns = [:nombre, :filename, :objeto, :updated_at, :registro]

    #Create
    config.create.multipart = true
    config.create.columns = [:nombre, :objeto, :uploaded_data, :registro]
    config.create.label = "Informe"

    #Update
    config.update.multipart = true
    config.update.columns = [:nombre, :objeto, :uploaded_data, :registro]
    config.update.label = "Informe"
    config.update.link.page = true
  end if Informe.table_exists?

  def parsea
    informe = Informe.find(params[:id])
    if informe.nil?
      render :update do |page|
        page << "alert('El informe seleccionado no existe (id: #{params[:id]})');"
      end
      return
    end
    objeto = informe.objeto.camelize.constantize.find(params[:objeto_id])
    if objeto.nil?
      render :update do |page|
        page << "alert('El objeto del que se desea sacar el informe no existe (#{informe.objeto} id: #{params[:objeto_id]})');"
      end
      return
    end
#    if request.get?
#      @id = params[:id]
#      @objeto_id = params[:objeto_id]
#      render :update do |page|
#        page.replace_html 'confirm_register', :partial => 'confirm_register'
#      end
#      return
#    else
      begin
        gd = informe.obtener_para(objeto)
        render :update do |page|
          page << "alert('El número de registro de #{gd.tipo} es el #{gd.num_registro}')" if gd.kind_of?(GestionDocumental)
          page.redirect_to :action => 'send_xml', :id => (gd.kind_of?(GestionDocumental) ? gd.documento.id : gd.id)
          page.replace_html 'confirm_register', ''
        end
      rescue Exception => e
        render :update do |page|
          page << %|alert('Se produjo un error al generar el informe "#{informe.nombre}" para el #{informe.objeto} con id #{objeto.id}: ' + #{e.message.to_json});|
        end
      end
#    end
  end

  def send_xml
    d = Documento.find(params[:id])
    data = File.open(d.full_filename).read
    nombre_fichero = d.filename
    send_data data, :type => 'application/msword', :disposition => "attachment; filename=#{nombre_fichero}"
  end

  def download
    documento = Informe.find(params[:id])
    send_file documento.full_filename, :type => documento.content_type, :file_name => documento.filename
  end
end
