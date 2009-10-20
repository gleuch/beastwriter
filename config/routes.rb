ActionController::Routing::Routes.draw do |map|

# Session routes
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'

  map.resource :session
  
# User routes
  map.resources :users, :member => { :suspend => [:put], :unsuspend => [:put], :purge => [:delete] } do |user|
    user.resource :posts, :controller => 'forum_posts', :collection => {:search => :get}
  end

  map.with_options :controller => 'users' do |user|
    user.register '/register', :action => 'create'
    user.signup '/signup', :action => 'new'
    # user.user_troubleshooting '/users/troubleshooting', :action => 'troubleshooting'
    # user.user_forgot_password '/users/forgot_password', :action => 'forgot_password'
    # user.user_reset_password '/users/reset_password/:password_reset_code', :action => 'reset_password'
    # user.user_forgot_login '/users/forgot_login', :action => 'forgot_login'
    # user.user_clueless '/users/clueless', :action => 'clueless'

    # user.user_update_email '/settings/account/email', :action => 'update_email', :panel => 'account', :conditions => {:method => [:post, :put]} #These were throwing errors due to duplication of required/optional
    # user.user_update_password '/settings/account/password', :action => 'update_password', :panel => 'account', :conditions => {:method => [:post, :put]}
    user.user_settings '/settings', :action => 'settings'
  end

# Admin routes
  map.namespace(:admin) do |admin|
    admin.resources :categories
    admin.resources :comments
    admin.resources :links
    admin.resources :entries
  end
  map.admin_path '/admin', :controller => 'admin/entries', :action => 'index'


# Blog routes
  map.resources :entries, :has_many => :comments
  map.resources :tags
  map.resources :categories
  map.archive_day '/archive/:year/:month/:day', :controller => 'entries', :action => 'archive'
  map.archive_month '/archive/:year/:month', :controller => 'entries', :action => 'archive'
  map.archive_year '/archive/:year', :controller => 'entries', :action => 'archive'


# Forum routes
  map.resources :forums do |forum|
    forum.resources :threads, :controller => 'forum_threads' do |thread|
      thread.resources :posts, :controller => 'forum_posts', :collection => {:search => :get}
    end
    forum.resources :posts, :controller => 'forum_posts', :collection => {:search => :get}
  end
  map.search_posts '/forum/search.:format', :controller => 'forum_posts', :action => 'search'


# Additional Routes

  # map.root :controller => 'forums', :action => 'index' # Homepage is forum
  map.root :controller => 'entries', :action => 'index' # Homepage is blog

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format' # Needed for pingbacks

end
