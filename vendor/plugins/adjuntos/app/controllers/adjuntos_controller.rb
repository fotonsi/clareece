class AdjuntosController < ApplicationController

  def adjuntar
    @record = params[:parent_type].constantize.find(params[:parent_id])
    if request.post?
      # Borrar ficheros eliminados
      (@record.adjuntos.map{|i| i.id} - params[:adjuntos].map{|i| i[:id].to_i}).each{|id|
        Adjunto.find(id).destroy
      }
      # Crear nuevos ficheros. No se tiene en cuenta los vacíos.
      params[:adjuntos].reject{|i| i["uploaded_data"].blank? }.each{|adjunto|
        @record.adjuntos.create!(adjunto) if not adjunto[:id]
      }
      @record.save
      @record.reload
      
      responds_to_parent do
        render :update do |page|
          page.remove "window_adjuntos"
          page.replace_html params[:remote_element_id], "(#{@record.adjuntos.size.to_s})"
        end
      end
    else
      render :update do |page|
        page.insert_html :after, params[:remote_element_id], :partial => 'form'
      end
    end
  end

  def download
    adjunto = Adjunto.find params[:id]
    send_file adjunto.full_filename, :type => adjunto.content_type, :file_name => adjunto.filename
  end

end
