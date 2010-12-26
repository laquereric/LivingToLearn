namespace :dropbox do

  desc "Log into DropBox - Create a session"
  task :login => :environment do
    p "Logging Into Dropbox"
    dropbox_session= Service::Dropbox.login
  end

  desc "Log out of DropBox - Destroy session"
  task :logout => :environment do
    p "Logging Out of Dropbox"
    dropbox_session= Service::Dropbox.logout
  end

end

