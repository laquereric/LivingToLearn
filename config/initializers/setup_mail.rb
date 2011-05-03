### TODO ActionMailer Config for test and development

  config = ActionMailer::Base

  config.raise_delivery_errors = true
  config.default :charset => "utf-8"

  if Rails.env != 'production'
    # A dummy setup for development - no deliveries, but logged
    config.default_url_options = { :host => 'localhost:3000' }
    config.delivery_method = :smtp
    config.perform_deliveries = false
  else
    config.default_url_options = { :host => 'LivingToLearn.com' }
    config.delivery_method = :sendmail
    config.sendmail_settings = {
      :arguments      => '-i -t'
    }
    config.action_mailer.perform_deliveries = false
  end

