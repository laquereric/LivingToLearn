ActionMailer::Base.default_url_options = { :host => 'LivingToLearn.com' }
ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.delivery_method = :sendmail
ActionMailer::Base.sendmail_settings = {
  :arguments      => '-i -t'
}

