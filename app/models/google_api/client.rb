require 'gdocs4ruby'

class GoogleApi::Client
  cattr_accessor :service

  def self.login
    return self.service if !self.service.nil?
    self.service = GDocs4Ruby::Service.new()
    self.service.authenticate( ENV['GOOGLE_MAIL'], ENV['GOOGLE_PASSWORD'] )
    return self.service
  end

end
