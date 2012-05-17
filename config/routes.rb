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
  		delete '/delete/:id', :action => :delete, :as => :new_customer_delete
  		scope '/show/:id', :controller => :new_customer do
        get '/',          :action => :show,      :as => :new_customer
        scope '/items' do
          get    '/',                action: :items,       as: :new_customer_items
          match  '/new',             action: :new_item,    as: :new_customer_new_item
          match  '/edit/:item_id',   action: :edit_item,   as: :new_customer_edit_item
          delete '/delete/:item_id', action: :delete_item, as: :new_customer_delete_item
        end
  		  get '/notes',     :action => :notes,     :as => :new_customer_notes
  		  scope '/docs', :controller => :new_customer do
          get    '/',                 action: :docs,         as: :new_customer_docs
          match  '/new',              action: :new_doc,      as: :new_customer_new_doc
          get    '/download/:doc_id', action: :download_doc, as: :new_customer_download_doc
          delete '/delete/:doc_id',   action: :delete_doc,   as: :new_customer_delete_doc
  		  end
  		end
  	end
  end

  root :to => 'site#index'
end