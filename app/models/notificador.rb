class Notificador < ActionMailer::Base
  def mensaje_matricula(destinatario, numero_solicitud)
    recipients destinatario
    recipients LOCAL_EMAIL if LOCAL_DELIVERY
    from EMAIL_SERVIDOR
    subject "Solicitud de matrícula realizada"
    content_type "text/html"
    body  :numero_solicitud => numero_solicitud
  end

  def mensaje_servidor(asunto, mensaje, destinatarios = [], fallos_emails = [], adjuntos = [])
    recipients destinatarios
    recipients LOCAL_EMAIL if LOCAL_DELIVERY
    from(Colegio.actual.email || EMAIL_SERVIDOR)
    subject asunto
    content_type "text/html"
    body  :mensaje => mensaje,
          :fallos_emails => fallos_emails
    adjuntos.each do |a|
        attachment :content_type => "text/plain", :filename => a, 
            :body => File.read(a)
    end
  end
end
