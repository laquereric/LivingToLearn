require 'dropbox'

class Service::Dropbox

  def self.dropbox_session_filename
    '/Users/eric/.dropbox_session'
  end

  def self.session
    serialized_dropbox_session= File.open( self.dropbox_session_filename ).read
    return Dropbox::Session.deserialize( serialized_dropbox_session )
  end

  def self.logged_in?
    return File.exists?( self.dropbox_session_filename)
  end

  def self.login
    dropbox_session = Dropbox::Session.new( ENV['DROPBOX_KEY'], ENV['DROPBOX_SECRET'] )
    puts "Visit #{dropbox_session.authorize_url} to log in to Dropbox. Hit enter when you have done this."
    STDIN.gets
    #"Visited #{dropbox_session.authorize_url} to log in to Dropbox. Hit enter when you have done this."
    #Browser.get_browser.goto(dropbox_session.authorize_url)
    dropbox_session.authorize
    File.open( self.dropbox_session_filename, 'w+' ) do |file|
      file.puts dropbox_session.serialize
    end
  end

  def self.logout
# re-serialize the authenticated session
    File.delete( self.dropbox_session_filename)
  end

end
