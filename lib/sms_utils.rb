module SmsUtils
  require 'builder'
  def self.deliver_sms(to, data)
    builder = Builder::XmlMarkup.new(:indent => 2)
    
    builder.instruct! :xml, :version => '1.0', :encoding => 'iso-8859-1'
    builder.sms do |b|
      b.user(USUARIO_SMS)
      b.password(PASSWORD_SMS)
      b.src(REMITENTE_SMS)
      b.dst {to.each {|n| b.num(n)}}
      b.txt(data)
    end
  end
end
