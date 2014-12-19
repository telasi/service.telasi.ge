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

  # magti routes
  scope '/magti', controller: :magti do
    get '/', action: :index, as: :magti
    get '/send_sms', action: :send_sms
  end

  # სისტემური ადმინისტრატორის მოქმედებები
  namespace :sys do
    scope '/users', :controller => :users do
      get   '/',            action: :index,  as: :users
      match '/edit/:id',    action: :edit,   as: :edit_user
      delete '/delete/:id', action: :delete, as: :delete_user
      get '/show/:id',      action: :show,   as: :show_user
      post '/confirm/:id/:accnumb', action: :confirm_acc, as: :confirm_acc
      delete '/remove/:id/:accnumb', action: :remove_acc, as: :remove_acc
    end
    scope '/regions', controller: :regions do
      get  '/',           action: :index,        as: :regions
      get  '/show/:id',   action: :region,       as: :region
      match '/edit/:id',  action: :edit,         as: :edit_region
      post '/setloc/:id', action: :set_location, as: :set_location
      post '/sync',       action: :sync_regions, as: :sync_regions
    end
    scope '/billoperation', controller: :billoperation do
      get '/', action: :index, as: :billoperations
      post '/sync', action: :sync, as: :billoperation_sync
      match '/edit/:id', action: :edit, as: :billoperation_edit
    end
    scope '/gis', controller: :gis do
      get '/', action: 'index', as: 'gis'
      # network object actions
      get '/transformators', action: :transformators, as: :transformators
      get '/sections', action: :sections, as: :sections
      get '/fiders', action: :fiders, as: :fiders
      post '/sync_transformators', action: :sync_transformators, as: :sync_transformators
      post '/sync_transformator/:id', action: :sync_transformator, as: :sync_transformator
      post '/sync_sections', action: :sync_sections, as: :sync_sections
      # log actions
      get '/logs', action: :logs, as: :gis_logs
      post '/sync_logs', action: :sync_logs, as: :sync_gis_logs
      # receiver actions
      get '/receivers', action: :receivers, as: :gis_receivers
      match '/receiver/new', action: :new_receiver, as: :gis_new_receiver
      match '/receiver/edit/:id', action: :edit_receiver, as: :gis_edit_receiver
      delete '/receiver/:id', action: :delete_receiver, as: :gis_delete_receiver
      # summary_receivers
      scope '/summary_receivers' do
        get '/', action: 'summary_receivers', as: 'gis_summary_receivers'
        match '/new', action: 'new_summary_receiver', as: 'new_gis_summary_receiver'
        match '/edit/:id', action: 'edit_summary_receiver', as: 'edit_gis_summary_receiver'
        delete '/:id', action: 'delete_summary_receiver', as: 'delete_gis_summary_receiver'
      end
      # summary_reports
      scope '/summary_reports' do
        get '/', action: 'summary_reports', as: 'gis_summary_reports'
        get '/show/:id', action: 'summary_report', as: 'gis_summary_report'
        ###
      end
      # messages
      get '/messages', action: :messages, as: :gis_messages
      get '/message/:id', action: :message, as: :gis_message
      post '/send/:id', action: :send_message, as: :gis_send
      get '/details', action: :details, as: :gis_details
      # reports
      scope '/reports' do
        get '/tp_statuses', action: 'tp_statuses', as: :gis_report_tp_statuses
        get '/network_status', action: 'network_status', as: :gis_network_status
        post '/network_status_sync', action: 'network_status_sync', as: :gis_network_status_sync
        match '/network_status/edit', action: 'network_status_edit', as: :gis_network_status_edit
        post '/network_status/send', action: 'network_status_send', as: :gis_network_status_send
      end
    end
  end

  get '/gis' => redirect('/sys/gis')

  # განცხადებები
  namespace :apps do
  	scope :controller => :applications do
  		get '/', :action => :index, :as => :home
  	end
  	# ქსელზე მიერთება
  	scope '/new_customer', :controller => :new_customer do
  	  get   '/print/:id',        action: :print,       as: :print
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

  # Android-ის მომსახურების სერვისები.
  namespace :android do
    scope controller: :android do
      get '/', action: :index, as: :home
      get '/login', action: :authenticate, as: :authenticate
      get '/users', action: :users, as: :users
      get 'routes', action: :routes, as: :routes
      get 'route/:id', action: :route, as: :route
      post '/sync_users', action: :sync_logins, as: :sync_logins
    end
    scope '/readings', controller: :readings do
      get '/reesters',   action: :reesters,   as: :reesters
      get '/reester',    action: :reester,    as: :reester
      post '/upload',    action: :upload,     as: :upload_reester
      post '/newmeters', action: :newmeters,  as: :newmeters
      post '/sync/:id',  action: :sync_route, as: :sync_route
    end
  end

  # cra.ge web services
  namespace :cra, controller: :cra do
    get '/', action: :index
    get '/by_id_card', action: :by_id_card, as: :by_id_card
    get '/by_name_and_dob', action: :by_name_and_dob, as: :by_name_and_dob
    get '/by_address/:id', action: :by_address, as: :by_address
    get '/history', action: :history, as: :history
  end

  # Call Center
  namespace :call do
    scope controller: :main do
      get '/', action: :index, as: :home
      get '/print_tasks', action: :print_tasks, as: :print_tasks
      post '/complete/:id', action: :complete_task, as: :complete_task
      post '/sync_tasks', action: :sync_tasks, as: :sync_tasks
      get '/all', action: 'all', as: 'all_tasks'
    end
    scope controller: :customers do
      get '/search', action: :index, as: :customer
      get '/info/:custkey', action: :customer_info, as: :customer_info
      get '/items/:custkey', action: :items, as: :customer_items
      get '/item/:itemkey', action: :item, as: :customer_item
      get '/cuts/:custkey', action: :cuts, as: :customer_cuts
      get '/cut/:cutkey', action: :cut, as: :customer_cut
      get '/trashitems/:custkey', action: :trash_items, as: :customer_trash_items
      get '/trashitem/:trashitemid', action: :trash_item, as: :customer_trash_item
      get '/tariffs/:custkey', action: :tariff_history, as: :tariff_history
      # bill items
      get '/bills/:custkey', action: :bills, as: :customer_bills
      # tasks
      get '/tasks/:custkey', action: :tasks, as: :customer_tasks
      get '/tasks/show/:id', action: :task, as: :show_customer_task
      match '/tasks/new/:custkey', action: :new_task, as: :new_customer_task
      match '/tasks/edit/:id', action: :edit_task, as: :edit_customer_task
      delete '/tasks/delete/:id', action: :delete_task, as: :delete_customer_task
      match '/tasks/comments/new/:id', action: :new_comment, as: :new_task_comment
      match '/tasks/comments/edit/:id', action: :edit_comment, as: :edit_task_comment
      delete '/tasks/comments/delete/:id', action: :delete_comment, as: :delete_task_comment
      post '/tasks/send/:id', action: :send_task, as: :send_task
    end
    scope controller: :admin do
      get    '/admin',                     action: :index,         as: :admin
      # stats
      get    '/statuses',                  action: :statuses,      as: :statuses
      match  '/admin/statuses/new',        action: :new_status,    as: :new_status
      match  '/admin/statuses/edit/:id',   action: :edit_status,   as: :edit_status
      delete '/admin/statuses/delete/:id', action: :delete_status, as: :delete_status
      # regions
      get    '/admin/regions',             action: :regions,       as: :regions
      post   '/admin/regions/sync',        action: :sync_regions,  as: :sync_regions
      match  '/admin/regions/edit/:id',    action: :edit_region,   as: :edit_region
      delete '/admin/regions/delete/:id',  action: :delete_region, as: :delete_region
      # docs
      get    '/admin/docs',                action: :docs,          as: :admin_docs
      match  '/admin/docs/new',            action: :new_doc,       as: :new_doc
      match  '/admin/docs/edit/:id',       action: :edit_doc,      as: :edit_doc
      delete '/admin/docs/delete/:id',     action: :delete_doc,    as: :delete_doc
      # categories
      scope '/admin/categories' do
        get '/', action: 'categories', as: 'categories'
        match '/new', action: 'new_category', as: 'new_category'
        match '/edit/:id', action: 'edit_category', as: 'edit_category'
        delete '/delete/:id', action: 'delete_category', as: 'delete_category'
      end
    end
    scope controller: :docs do
      get '/docs', action: :index, as: :docs
      get '/docs/show/:id', action: :show, as: :show_doc
    end
    scope 'outages', controller: 'outages' do
      get '/', action: 'index', as: 'outages'
      get '/archive', action: 'archive', as: 'outage_archive'
      get '/show/:id', action: 'show', as: 'outage'
      match '/new', action: 'new', as: 'new_outage'
      match '/edit/:id', action: 'edit', as: 'edit_outage'
      delete '/delete/:id', action: 'delete', as: 'delete_outage'
      post '/on/:id', action: 'on', as: 'outage_on'
      post '/ons', action: 'ons', as: 'outage_ons'
    end
  end

  root :to => 'site#index'
end
