ActionController::Routing::Routes.draw do |map|

  # # Public Routes
  # map.root :controller => "entries", :action => "index"
  # 
  # map.resources :entries, :has_many => :comments
  # map.resources :tags
  # map.resources :categories
  # 
  # map.archive_day 'archive/:year/:month/:day', :controller => 'entries', :action => 'archive'
  # map.archive_month 'archive/:year/:month', :controller => 'entries', :action => 'archive'
  # map.archive_year 'archive/:year', :controller => 'entries', :action => 'archive'
  # 
  # # Admin Routes
  # map.namespace(:admin) do |admin|
  #   admin.resources :categories
  #   admin.resources :comments
  #   admin.resources :links
  #   admin.resources :entries
  # end
  # 
  # # Needed for pingbacks
  # map.connect ':controller/:action/:id.:format'
  
  # map.open_id_complete '/session', 
  #   :controller => "sessions", :action => "create",
  #   :requirements => { :method => :get }
  # 
  # map.resources :sites, :moderatorships, :monitorship
  # 
  # 
  # map.resources :forums, :has_many => :posts do |forum|
  #   forum.resources :topics do |topic|
  #     topic.resources :posts
  #     topic.resource :monitorship
  #   end
  #   forum.resources :posts
  # end
  # 
  # map.resources :posts, :collection => {:search => :get}
  # map.resources :users, :member => { :suspend   => :put,
  #                                    :settings  => :get,
  #                                    :make_admin => :put,
  #                                    :unsuspend => :put,
  #                                    :purge     => :delete },
  #                       :has_many => [:posts]
  # 
  # map.activate '/activate/:activation_code', :controller => 'users',    :action => 'activate', :activation_code => nil
  # map.signup   '/signup',                    :controller => 'users',    :action => 'new'
  # map.login    '/login',                     :controller => 'sessions', :action => 'new'
  # map.logout   '/logout',                    :controller => 'sessions', :action => 'destroy'
  # map.settings '/settings',                  :controller => 'users',    :action => 'settings'
  # map.resource  :session
  # 
  # map.with_options :controller => 'posts', :action => 'monitored' do |map|
  #   map.formatted_monitored_posts 'users/:user_id/monitored.:format'
  #   map.monitored_posts           'users/:user_id/monitored'
  # end
  # 
  # map.root :controller => 'forums', :action => 'index'

end
