ActionController::Routing::Routes.draw do |map|
  map.resource :account, :controller => "users"
  map.resources :users
  map.resource :user_session
  map.root :controller => "user_sessions", :action => "new"
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate'

   map.namespace :admin do |admin|
      admin.resources :users
    end

end
