# app/mailers/user_mailer.rb
class ReadingMailer < ActionMailer::Base
  default :from => "LaquerEric@gmail.com"
  
  def test
    #@user = user
    #attachments["rails.png"] = File.read("#{Rails.root}/public/images/rails.png")
    mail(:to => "Eric Laquer <LaquerEric@gmail.com>", :subject => "Test2")
  end
end

