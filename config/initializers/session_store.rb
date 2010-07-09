# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_degrees_session',
  :secret      => '02b1d7db0aacf5953d121997a0c2db57db58e1b2a9b1bf8fce1b0eb493c0fe9cc3ae79b31cad6293eda8bed6cefc7b6ec4a7beb43199cc79b795b2f8b0394a0a'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
