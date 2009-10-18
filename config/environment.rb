# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.3' unless defined? RAILS_GEM_VERSION


# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.gem 'mislav-will_paginate', :lib => "will_paginate", :source => "http://gems.github.com"
  config.gem "bluecloth"
  config.gem 'RedCloth', :lib => "redcloth", :source => "http://code.whytheluckystiff.net"

  # Skip frameworks you're not going to use (only works if using vendor/rails).
  # To use Rails without a database, you must remove the Active Record framework
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Only load the plugins named here, in the order given. By default, all plugins 
  # in vendor/plugins are loaded in alphabetical order.
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/concerns )

  # Force all environments to use the same logger level
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Your secret key for verifying cookie session data integrity.
  # If you change this key, all old sessions will become invalid!
  # Make sure the secret is at least 30 characters and all random, 
  # no regular words or you'll be exposed to dictionary attacks.
  config.action_controller.session = {
    :session_key => '_altered_beast_session',
    :secret      => 'f471415647be47dc513d5e345ca4e582a8f99f388e0ccd46a2cdac51e2cd27c8e8b4d7dbba379cf661d4857afaf6b1867489bbc5e16b5fb14d2c3e53df64c272'
  }

  # Use the database for sessions instead of the cookie-based default,
  # which shouldn't be used to store highly confidential information
  # (create the session table with 'rake db:sessions:create')
  # config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector

  # Make Active Record use UTC-base instead of local time
  config.active_record.default_timezone = :utc

  # The internationalization framework can be changed 
  # to have another default locale (standard is :en) or more load paths.
  # All files from config/locales/*.rb,yml are added automatically.
  # config.i18n.load_path << Dir[File.join(RAILS_ROOT, 'my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :en

end

Pingback.save_callback do |ping|
    comment = Comment.new
    comment.alias      = ping.title
    comment.website    = ping.source_uri
    comment.comment    = ping.content
    comment.created_at = ping.time

    referenced_entry = Entry.find_by_url(ping.target_uri)

    if referenced_entry
      comment.entry_id = referenced_entry.id
      comment.save

      ping.reply_ok # report success.
    else
      # report error:
      ping.reply_target_uri_does_not_accept_entrys
    end
  end
end