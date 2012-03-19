TelasiService::Application.routes.draw do
  get 'site/index'

  get '/home', :controller => :site, :action => :index, :as => :home
  match '/register', :controller => :site, :action => :register, :as => :register
  match '/login', :controller => :site, :action => :login, :as => :login

  root :to => 'site#index'
end
