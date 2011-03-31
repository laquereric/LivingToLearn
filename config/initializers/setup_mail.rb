# config/initializers/setup_mail.rb
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  #:address              => "mail.LivingToLearn.com",
  :address              => "localhost",
  :port                 => 25,
  :domain               => "LivingToLearn.com",
  :user_name            => "eric",
  :password             => "Pepper169",
  :authentication       => "plain",
  :enable_starttls_auto => true
}

#ActionMailer::Base.default_url_options[:host] = "localhost:3000"
#Mail.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?

