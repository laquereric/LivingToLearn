require 'gdocs4ruby'

class GoogleApi::Client
  cattr_accessor :service

  def self.service_class
    GDocs4Ruby::Service
  end

  def self.login
    return self.service if !self.service.nil?
    self.service =  service_class.new()
    self.service.authenticate( ENV['GOOGLE_MAIL'], ENV['GOOGLE_PASSWORD'] )
    return self.service
  end

end
