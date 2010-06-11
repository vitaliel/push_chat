# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_push_session',
  :secret      => '1d9f0b9d13a8791db9674d8871b6092b238a3fac480da1a3438bf51d44be978c27f5d1ea9e590c6cc533531d805a8ffe5058b25829f4575b1e50a342b9bccd82'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
