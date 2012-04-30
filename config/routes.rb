# -*- encoding : utf-8 -*-
TelasiService::Application.routes.draw do
  get 'site/index'

  # საიტის მოქმედებები
  get '/home', :controller => :site, :action => :index, :as => :home

  # დახმარება
  scope '/help', :controller => :help do
    get '/(:tutorial/:section)', :action => :index, :as => :help
  end

  # მოქმედებები მომხმარებელზე
  scope '/user', :controller => :users do
    match '/register',        :action => :register
    get   '/confirm',         :action => :confirm
    match '/login',           :action => :login
    match '/account',         :action => :account
    match '/change_password', :action => :change_password
    match '/restore',         :action => :restore,        :as => :restore_password
    match '/new_password',    :action => :new_password,   :as => :new_password
    get   '/logout',          :action => :logout
    match '/photo',           :action => :photo,          :as => :user_photo
  end

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
