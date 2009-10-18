# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.3' unless defined? RAILS_GEM_VERSION


# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.gem "haml", :version => "~>2.2.0"
  config.gem "configatron", :version => ">= 2.2.2"
  config.gem 'mislav-will_paginate', :lib => "will_paginate", :source => "http://gems.github.com"
  config.gem "bluecloth"
  config.gem "rubyist-aasm", :lib => "aasm", :version => "~> 2.0.5"
  config.gem 'RedCloth', :lib => "redcloth", :source => "http://code.whytheluckystiff.net"
  config.gem "norman-friendly_id", :lib => 'friendly_id', :source => 'http://gems.github.com'  
  config.gem "moomerman-twitter_oauth", :lib => 'twitter_oauth', :source => 'http://gems.github.com'

  # testing poison of choice -- no libs are require'd by the app itself, but manages a proper testing setup w/ `rake gems:install`
  config.gem "rspec", :lib => false, :version => ">= 1.2.0" 
  config.gem "rspec-rails", :lib => false, :version => ">= 1.2.0"   
  config.gem "aslakhellesoy-cucumber", :lib => false, :source => 'http://gems.github.com'
  config.gem "thoughtbot-factory_girl", :lib => false, :source => "http://gems.github.com"
  config.gem "jscruggs-metric_fu", :lib => false, :source => 'http://gems.github.com'
  config.gem 'timcharper-spork', :lib => false, :source => 'http://gems.github.com'
  config.gem 'freelancing-god-thinking-sphinx', :lib => 'thinking_sphinx', :source => 'http://gems.github.com'  
  config.gem 'javan-whenever', :lib => false, :source => 'http://gems.github.com'


  config.active_record.default_timezone = :utc
  # config.active_record.observers = :user_observer

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