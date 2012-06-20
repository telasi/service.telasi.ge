# -*- encoding : utf-8 -*-
TelasiService::Application.routes.draw do
  get 'site/index'

  # საიტის მოქმედებები
  get '/home',         controller: :site, action: :index,        as: :home
  get '/new_customer', controller: :site, action: :new_customer, as: :site_new_customer
  post '/markdown',    controller: :site, action: :markdown

  # მოქმედებები მომხმარებელზე
  scope '/user', controller: :users do
    match '/register',        action: :register
    get   '/confirm',         action: :confirm
    match '/login',           action: :login
    match '/account',         action: :account
    match '/change_password', action: :change_password
    match '/restore',         action: :restore,        as: :restore_password
    match '/new_password',    action: :new_password,   as: :new_password
    get   '/logout',          action: :logout
    match '/photo',           action: :photo,          as: :user_photo
  end

  # დავალიანების მოქმედებები
  scope '/debt', controller: :debt do
    match  '/',                action: :index,           as: :debt
    post   '/add/:accnumb',    action: :add_customer,    as: :add_customer
    delete '/remove/:accnumb', action: :remove_customer, as: :remove_customer
  end

  # სისტემური ადმინისტრატორის მოქმედებები
  namespace :sys do
    scope '/users', :controller => :users do
      get   '/',            action: :index,  as: :users
      match '/edit/:id',    action: :edit,   as: :edit_user
      delete '/delete/:id', action: :delete, as: :delete_user
    end
    scope '/regions', controller: :regions do
      get  '/',           action: :index,    as: :regions
      post '/sync',       action: :sync,     as: :region_sync
      get  '/loc/:id',    action: :location, as: :region_location
      post '/setloc/:id', action: :setloc,   as: :set_location
    end
  end

  # განცხადებები
  namespace :apps do
  	scope :controller => :applications do
  		get '/', :action => :index, :as => :home
  	end
  	# ქსელზე მიერთება
  	scope '/new_customer', :controller => :new_customer do
  		match  '/new',             action: :new,         as: :new_customer_new
  		match  '/edit/:id',        action: :edit,        as: :new_customer_edit
  		delete '/delete/:id',      action: :delete,      as: :new_customer_delete
  		post   '/send/:id',        action: :sendapp,     as: :new_customer_send
  		post   '/approve/:id',     action: :approve,     as: :new_customer_approve
  		post   '/deprove/:id',     action: :deprove,     as: :new_customer_deprove
  		post   '/to_sent/:id',     action: :to_sent,     as: :new_customer_to_sent 
  		post   '/complete/:id',    action: :complete,    as: :new_customer_complete
  		post   '/to_complete/:id', action: :to_complete, as: :new_customer_to_complete
  		scope '/show/:id', :controller => :new_customer do
        get '/',          :action => :show,      :as => :new_customer
        scope '/items' do
          get    '/',                action: :items,       as: :new_customer_items
          match  '/new',             action: :new_item,    as: :new_customer_new_item
          match  '/edit/:item_id',   action: :edit_item,   as: :new_customer_edit_item
          delete '/delete/:item_id', action: :delete_item, as: :new_customer_delete_item
        end
        scope '/payments' do
          get    '/',               action: :payments,        as: :new_customer_payments
          match  '/new',            action: :new_payment,     as: :new_customer_new_payment
          match  '/edit/:pay_id',   action: :edit_payment,    as: :new_customer_edit_payment
          delete '/delete/:pay_id', action: :delete_payment,  as: :new_customer_delete_payment
        end
        scope '/notes' do
          get   '/',    action: :notes,    as: :new_customer_notes
          match '/new', action: :new_note, as: :new_customer_new_note
        end
  		  scope '/docs', :controller => :new_customer do
          get    '/',                 action: :docs,         as: :new_customer_docs
          match  '/new',              action: :new_doc,      as: :new_customer_new_doc
          match  '/edit/:doc_id',     action: :edit_doc,     as: :new_customer_edit_doc
          get    '/download/:doc_id', action: :download_doc, as: :new_customer_download_doc
          delete '/delete/:doc_id',   action: :delete_doc,   as: :new_customer_delete_doc
  		  end
  		end
  	end
  end

  root :to => 'site#index'
end
