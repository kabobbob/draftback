# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_draftback_session',
  :secret      => '24d02a4b63a2990c07bd1a14d77ff404eadb0e0d851c7eab9d4cad926b78fd3eea0d627afd0564d0a795fa2c9a717b9117fa9ffb093a7363bb3c2baeed0ab36f'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
