class ComunicacionesController < ApplicationController
  include Authentication
  before_filter :access_authorized?
  def index
    render :text => "Comunicaciones"
  end

  def enviar_sms
    if request.post?
      tlfs = params[:dest].values.map {|n| Colegiado.find(n["numero"]).telefonos.split(" ").grep /^6/}.flatten
      xml = SmsUtils::deliver_sms(tlfs, params[:text])
      render :text => xml
    end
  end

  def nuevo_destinatario
    render :update do |page|
      page.insert_html :bottom, 'destinatarios', :partial => 'destinatario'
    end
  end
end
