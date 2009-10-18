ActionController::Routing::Routes.draw do |map|

# Session routes
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'

  map.resource :session

# Admin routes
  map.namespace(:admin) do |admin|
    admin.resources :categories
    admin.resources :comments
    admin.resources :links
    admin.resources :entries
  end


# Blog routes
  map.resources :entries, :has_many => :comments
  map.resources :tags
  map.resources :categories
  map.archive_day '/archive/:year/:month/:day', :controller => 'entries', :action => 'archive'
  map.archive_month '/archive/:year/:month', :controller => 'entries', :action => 'archive'
  map.archive_year '/archive/:year', :controller => 'entries', :action => 'archive'


# Forum routes
  map.resources :sites, :moderatorships, :monitorship

  map.resources :forums, :has_many => :posts do |forum|
    forum.resources :topics do |topic|
      topic.resources :posts
      topic.resource :monitorship
    end
    forum.resources :posts
  end

  map.resources :posts, :collection => {:search => :get}

  map.with_options :controller => 'posts', :action => 'monitored' do |map|
    map.formatted_monitored_posts '/users/:user_id/monitored.:format'
    map.monitored_posts           '/users/:user_id/monitored'
  end


# User routes
  map.resources :users, :member => { :suspend => [:put], :unsuspend => [:put], :purge => [:delete] }
  map.with_options :controller => 'users' do |user|
    user.register '/register', :action => 'create'
    user.signup '/signup', :action => 'new'
  end



# Additional Routes

  # map.root :controller => 'forums', :action => 'index' # Homepage is forum
  map.root :controller => 'entries', :action => 'index' # Homepage is blog

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format' # Needed for pingbacks

end
