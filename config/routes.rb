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

  # განცხადებები
  namespace :apps do
  	scope :controller => :applications do
  		get '/', :action => :index, :as => :home
  	end
  	# ქსელზე მიერთება
  	scope '/new_customer', :controller => :new_customer do
  		match  '/new',        :action => :new,    :as => :new_customer_new
  		match  '/edit/:id',   :action => :edit,   :as => :new_customer_edit
  		get    '/show/:id',   :action => :show,   :as => :new_customer
  		delete '/delete/:id', :action => :delete, :as => :new_customer_delete 
  	end
  end

  root :to => 'site#index'
end

