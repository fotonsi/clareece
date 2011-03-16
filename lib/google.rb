module Google
  require 'gdata'

  def self.login(login, password, captcha_token, captcha_answer)
    client = GData::Client::Apps.new
    begin
      client.clientlogin(login, password, captcha_token, captcha_answer)
    rescue Exception => e
      #STDERR.puts e.url if e.respond_to?("url")
      raise e
    end
    return true
  end
end
