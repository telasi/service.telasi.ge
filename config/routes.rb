# -*- encoding : utf-8 -*-
TelasiService::Application.routes.draw do
  get 'site/index'

  get '/home', :controller => :site, :action => :index, :as => :home
  get '/help', :controller => :site, :action => :help, :as => :help
  match '/register', :controller => :site, :action => :register, :as => :register
  match '/login', :controller => :site, :action => :login, :as => :login
  get '/logout', :controller => :site, :action => :logout, :as => :logout
  get '/confirm', :controller => :site, :action => :confirm, :as => :confirm

  root :to => 'site#index'
end
