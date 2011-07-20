# Be sure to restart your server when you modify this file.


case Rails.env
  when 'development'
    LivingToLearn::Application.config.session_store :active_record_store, :domain => 'lvh.me' , :key => '_living_to_learn_session'
  when 'production'
    LivingToLearn::Application.config.session_store :active_record_store, :domain => 'livingtolearn.com' , :key => '_living_to_learn_session'
end

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# LivingToLearn::Application.config.session_store :active_record_store
