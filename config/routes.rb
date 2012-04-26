# -*- encoding : utf-8 -*-
TelasiService::Application.routes.draw do
  get 'site/index'

  # site actions
  get '/home', :controller => :site, :action => :index, :as => :home

  # help actions
  scope '/help', :controller => :help do
    get '/(:tutorial/:section)', :action => :index, :as => :help
  end

  # user actions
  scope '/user', :controller => :users do
    match '/register', :action => :register
    match '/login', :action => :login
  end

#  match '/register', :controller => :site, :action => :register, :as => :register
#  match '/login', :controller => :site, :action => :login, :as => :login
#  get '/logout', :controller => :site, :action => :logout, :as => :logout
#  get '/confirm', :controller => :site, :action => :confirm, :as => :confirm
#  match '/account', :controller => :site, :action => :account, :as => :account
#  match '/change_password', :controller => :site, :action => :change_password, :as => :change_password

#  # application actions
#  scope '/app', :controller => :applications do
#    get '/tariffs', :action => :tariffs, :as => :tariffs
#    match '/new', :action => :new, :as => :new_application
#    get '/show/:id', :action => :show, :as => :show_application
#    get '/print/:id', :action => :print, :as => :print_application
#    match '/edit/:id', :action => :edit, :as => :edit_application
#    delete '/delete/:id', :action => :delete, :as => :delete_application
#    scope '/item' do
#      match '/new/:id', :action => :new_item, :as => :new_application_item
#      match '/edit/:app_id/:id', :action => :edit_item, :as => :edit_application_item
#      delete '/delete/:app_id/:id', :action => :delete_item, :as => :delete_application_item
#    end
#  end

  root :to => 'site#index'
end
