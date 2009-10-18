ActionController::Routing::Routes.draw do |map|

  # Public Routes
  map.root :controller => "entries", :action => "index"

  map.resources :entries, :has_many => :comments
  map.resources :tags
  map.resources :categories

  map.archive_day 'archive/:year/:month/:day', :controller => 'entries', :action => 'archive'
  map.archive_month 'archive/:year/:month', :controller => 'entries', :action => 'archive'
  map.archive_year 'archive/:year', :controller => 'entries', :action => 'archive'

  # Admin Routes
  map.namespace(:admin) do |admin|
    admin.resources :categories
    admin.resources :comments
    admin.resources :links
    admin.resources :entries
  end

  # Needed for pingbacks
  map.connect ':controller/:action/:id.:format'
  
end
