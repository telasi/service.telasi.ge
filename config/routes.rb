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

  # აბონენტზე ინფორმაციის მიღება
  scope '/customer', controller: :customer do
    # ზოგადი
    get    '/',                 action: :index,           as: :debt
    post   '/add/:accnumb',     action: :add_customer,    as: :add_customer
    delete '/remove/:accnumb',  action: :remove_customer, as: :remove_customer
    # ისტორიის ნახვა
    get    '/history/:accnumb',               action: :history, as: :history
    get    '/history/:accnumb/item/:itemkey', action: :item,    as: :history_item
    # დასუფთავების ისტორია
    get    '/trash_history/:accnumb', action: :trash_history, as: :trash_history
  end

  scope '/map', controller: :map do
    get '/', action: :index, as: :map
  end

  # სისტემური ადმინისტრატორის მოქმედებები
  namespace :sys do
    scope '/users', :controller => :users do
      get   '/',            action: :index,  as: :users
      match '/edit/:id',    action: :edit,   as: :edit_user
      delete '/delete/:id', action: :delete, as: :delete_user
    end
    scope '/regions', controller: :regions do
      get  '/',           action: :index,        as: :regions
      get  '/show/:id',   action: :region,       as: :region
      match '/edit/:id',  action: :edit,         as: :edit_region
      get  '/'
      post '/setloc/:id', action: :set_location, as: :set_location
      post '/sync',       action: :sync_regions, as: :sync_regions
    end
    scope '/billoperation', controller: :billoperation do
      get '/', action: :index, as: :billoperations
      post '/sync', action: :sync, as: :billoperation_sync
      match '/edit/:id', action: :edit, as: :billoperation_edit
    end
    scope '/gis', controller: :gis do
      # transformator actions
      get '/transformators', action: :transformators  , as: :transformators
      post '/sync_transformators', action: :sync_transformators, as: :sync_transformators
      post '/sync_transformator/:id', action: :sync_transformator, as: :sync_transformator
      # log actions
      get '/logs', action: :logs, as: :gis_logs
      post '/sync_logs', action: :sync_logs, as: :sync_gis_logs
      # receiver actions
      get '/receivers', action: :receivers, as: :gis_receivers
      match '/receiver/new', action: :new_receiver, as: :gis_new_receiver
      match '/receiver/edit/:id', action: :edit_receiver, as: :gis_edit_receiver
      delete '/receiver/:id', action: :delete_receiver, as: :gis_delete_receiver
      # messages
      get '/messages', action: :messages, as: :gis_messages
      get '/message/:id', action: :message, as: :gis_message
      post '/send/:id', action: :send_message, as: :gis_send
      get '/accounts', action: :accounts, as: :gis_accounts
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
