# -*- encoding : utf-8 -*-
class Call::CustomersController < ApplicationController

  before_filter :validate_login

  def render(*args)
    navbuttons
    super
  end

  def index
    @title = 'აბონენტების ძებნა'
    @search_form = CustomerForm.search(params[:dim])
    @customers = search_customers(params[:dim], params[:page])
    @customer_table = CustomerForm.customer_table(@customers)
  end

  # customer

  def customer_info
    @title = 'მონაცემები აბონენტზე'
    @customer = Bs::Customer.where(custkey: params[:custkey]).first
    @customer_form = CustomerForm.customer_form(@customer)
    @trash_customer_form = TrashCustomerForm.customer_form(@customer.trash_customer)
    @trash_customer_form.collapsed = true
    @water_customer_form = WaterCustomerForm.customer_form(@customer)
    @water_customer_form.collapsed = true
    @account_forms = []
    @customer.accounts.each do |acc|
      form = AccountForm.account_form(acc)
      form.collapsed = true
      @account_forms << form
    end
  end

  def items
    @title = 'აბონენტის ისტორია'
    @customer = Bs::Customer.where(custkey: params[:custkey]).first
    @items = Bs::Item.where(custkey: @customer.custkey).order('ITEMKEY desc').paginate(page: params[:page], per_page: 15)
    @item_table = ItemForm.item_table(@items)
    @customer_form = CustomerForm.customer_form(@items.first.customer) unless @items.empty?
    @customer_form.collapsed = true
  end

  def item
    @title = 'ოპერაციის დეტალები'
    @item = Bs::Item.where(itemkey: params[:itemkey]).first
    @customer = @item.customer
    @account = @item.account
    @item_form = ItemForm.item_form(@item)
    @account_form = AccountForm.account_form(@item.account)
    @account_form.collapsed = true
    @customer_form = CustomerForm.customer_form(@customer, {title: 'აბონენტი'})
    @customer_form.collapsed = true
  end

  def cuts
    @title = 'ჩაჭრების ისტორია'
    @customer = Bs::Customer.where(custkey: params[:custkey]).first
    @cuts = Bs::CutHistory.where(custkey: params[:custkey]).order('OPER_DATE desc').paginate(page: params[:page], per_page: 15)
    @cut_table = CutForm.cut_table(@cuts)
    @customer_form = CustomerForm.customer_form(@customer, {title: 'აბონენტი'})
    @customer_form.collapsed = true
  end

  def cut
    @title = 'ოპერაციის დეტალები'
    @cut = Bs::CutHistory.where(cr_key: params[:cutkey]).first
    @customer = @cut.customer
    @cut_form = CutForm.cut_form(@cut)
    @account_form = AccountForm.account_form(@cut.account)
    @account_form.collapsed = true
    @customer_form = CustomerForm.customer_form(@cut.customer, {title: 'აბონენტი'})
    @customer_form.collapsed = true
  end

  def trash_items
    @title = 'დასუფთავების ისტორია'
    @customer = Bs::Customer.where(custkey: params[:custkey]).first
    @trash_items = Bs::TrashItem.where(custkey: @customer.custkey).order('TRASHITEMID desc').paginate(page: params[:page], per_page: 15)
    @trash_table = TrashItemForm.item_table(@trash_items)
    @trash_customer_form = TrashCustomerForm.customer_form(@customer.trash_customer)
    @trash_customer_form.collapsed = true
  end

  def trash_item
    @title = 'ოპერაციის დეტალები'
    @trash_item = Bs::TrashItem.where(trashitemid: params[:trashitemid]).first
    @customer = @trash_item.customer
    @trash_item_form = TrashItemForm.item_form(@trash_item)
    @trash_customer_form = TrashCustomerForm.customer_form(@customer.trash_customer)
    @trash_customer_form.collapsed = true
  end

  def tariff_history
    @title = 'ტარიფების ისტორია'
    @customer = Bs::Customer.where(custkey: params[:custkey]).first
    @customer_form = CustomerForm.customer_form(@customer)
    @customer_form.collapsed = true
    @accounts = @customer.accounts
    @tariffs = {}
    @accounts.each do |acc|
      @tariffs[acc] = AccountForm.account_tariff_table(acc)
    end
    @steps = []
    [100, 101, 200, 201, 300, 301].each do |key|
       @steps << AccountForm.tariff_steps(Bs::Tariff.find(key))
    end
  end

  # tasks

  def tasks
    @title = 'დავალებები'
    @customer = Bs::Customer.where(custkey: params[:custkey]).first
    @tasks = Call::Task.where(custkey: @customer.custkey).desc(:_id)
    @customer_form = CustomerForm.customer_form(@customer)
    @customer_form.collapsed = true
    @tasks_table = TaskForm.task_table(@tasks, @customer)
  end

  def task
    @title = 'დავალება'
    @task = Call::Task.where(_id: params[:id]).first
    @customer = @task.customer
    @customer_form = CustomerForm.customer_form(@customer)
    @customer_form.collapsed = true
    @task_form = TaskForm.task_form(@task, current_user)
    @comments_form = TaskForm.comments_table(@task)
  end

  def new_task
    @title = 'ახალი დავალება'
    @customer = Bs::Customer.where(custkey: params[:custkey]).first
    if validate_last_task(@customer)
      @customer_form = CustomerForm.customer_form(@customer)
      @customer_form.collapsed = true
      @new_task_form = TaskForm.edit_task_form(nil, @customer, auth_token)
      @new_task = Call::Task.new
      if request.post?
        @new_task_form << params[:dim]
        if @new_task_form.valid?
          @new_task_form >> @new_task
          @new_task.user = current_user
          @new_task.region = Ext::Region.where(regionkey: @customer.address.region.regionkey).first
          @new_task.custkey = @customer.custkey
          @new_task.save
          @new_task.send_by(current_user) if Call.call_center_sms_send_time
          redirect_to call_show_customer_task_url(id: @new_task.id), notice: 'დავალება დამატებულია!'
        end
      end
    end
  end

  def edit_task
    @title = 'დავალების რედაქტირება'
    @task = Call::Task.where(_id: params[:id]).first
    @customer = @task.customer
    @customer_form = CustomerForm.customer_form(@customer)
    @customer_form.collapsed = true
    @edit_task_form = TaskForm.edit_task_form(@task, @customer, auth_token)
    if request.post?
      @edit_task_form << params[:dim]
      if @edit_task_form.valid?
        @edit_task_form >> @task
        @task.save
        redirect_to call_show_customer_task_url(id: @task.id), notice: 'დავალება შეცვლილია!'
      end
    else
      @edit_task_form << @task
    end
  end

  def delete_task
    task = Call::Task.find(params[:id])
    custkey = task.custkey
    task.destroy
    redirect_to call_customer_tasks_url(custkey: custkey), notice: 'დავალება წაშლილია.'
  end

  def new_comment
    @title = 'ახალი დავალება'
    @task = Call::Task.find(params[:id])
    @customer = @task.customer
    @new_comment = Call::TaskComment.new
    @customer_form = CustomerForm.customer_form(@customer)
    @customer_form.collapsed = true
    @task_form = TaskForm.task_form(@task, current_user)
    @new_comment_form = TaskForm.edit_comment_form(nil, @task, auth_token)
    @new_comment = Call::TaskComment.new
    if request.post?
      @new_comment_form << params[:dim]
      if @new_comment_form.valid?
        @new_comment_form >> @new_comment
        @new_comment.user = current_user
        @new_comment.task = @task
        @new_comment.save
        redirect_to call_show_customer_task_url(id: @task.id), notice: 'კომენტარი დამატებულია!'
      end
    end
  end

  def edit_comment
    @title = 'კომენტარის რედაქტირება'
    @comment = Call::TaskComment.find(params[:id])
    @task = @comment.task
    @customer = @task.customer
    @customer_form = CustomerForm.customer_form(@customer)
    @customer_form.collapsed = true
    @task_form = TaskForm.task_form(@task, current_user)
    @edit_comment_form = TaskForm.edit_comment_form(@comment, @task, auth_token)
    if request.post?
      @edit_comment_form << params[:dim]
      if @edit_comment_form.valid?
        @edit_comment_form >> @comment
        @comment.save
        redirect_to call_show_customer_task_url(id: @task.id), notice: 'დავალება შეცვლილია!'
      end
    else
      @edit_comment_form << @comment
    end
  end

  def delete_comment
    comment = Call::TaskComment.find(params[:id])
    task = comment.task
    comment.destroy
    redirect_to call_show_customer_task_url(id: task.id), notice: 'კომენტარი წაშლილია.'
  end

  def send_task
    task = Call::Task.where(_id: params[:id]).first
    task.send_by(current_user)
    redirect_to call_show_customer_task_url(id: task.id), notice: 'დავალების შეტყობინება გაგზავნილია'
  end

  private

  def navbuttons
    @nav = { 'მთავარი' => call_home_url, 'ძებნა' => call_customer_url }
    @nav[@customer.custname.to_ka] = call_customer_info_url(custkey: @customer.custkey) if @customer
    if @item or @items
      @nav['დარიცხვის ისტორია'] = call_customer_items_url(custkey: @customer.custkey)
      @nav['ოპერაციის დეტალები'] = call_customer_item_url(itemkey: @item.itemkey) if @item
    end
    if @cut or @cuts
      @nav['ჩაჭრის ისტორია'] = call_customer_cuts_url(custkey: @customer.custkey)
      @nav['ოპერაციის დეტალები'] = call_customer_cut_url(cutkey: @cut.cr_key) if @cut
    end
    if @trash_item or @trash_items
      @nav['დასუფთავების ისტორია'] = call_customer_trash_items_url(custkey: @customer.custkey)
      @nav['ოპერაციის დეტალები'] = call_customer_trash_item_url(trashitemid: @trash_item.trashitemid) if @trash_item
    end
    if @tasks or @new_task or @task
      @nav['დავალებები'] = call_customer_tasks_url(custkey: @customer.custkey)
      @nav['ახალი დავალება'] = call_customer_tasks_url(custkey: @customer.custkey) if @new_task
      @nav['დავალების დეტალები'] = call_show_customer_task_url(id: @task.id) if @task
      @nav['ახალი კომენტარი'] = nil if @new_comment
      @nav['კომენტარის რედაქტირება'] = nil if @comment
    end
    if @tariffs
      @nav['ტარიფების ისტორია'] = call_tariff_history_url(custkey: @customer.custkey)
    end
  end

  def search_customers(params, page)
    conditions = []
    values = {}
    join_address = false
    join_regions = false
    join_street = false
    unless params.blank?
      unless params[:accnumb].blank?
        conditions << 'customer.accnumb LIKE :accnumb'
        values[:accnumb] = "%#{params[:accnumb].strip.to_geo}%"
      end
      unless params[:custname].blank?
        conditions << 'customer.custname LIKE :custname'
        values[:custname] = "%#{params[:custname].strip.to_geo}%"
      end
      unless params[:regionname].blank?
        conditions << 'region.regionname LIKE :regionname'
        values[:regionname] = "%#{params[:regionname].strip.to_geo}%"
        join_address = join_regions = true
      end
      unless params[:streetname].blank?
        conditions << 'street.streetname LIKE :streetname'
        str_search = params[:streetname].split(' ').join('%')
        values[:streetname] = "%#{str_search.to_geo}%"
        join_address = join_street = true
      end
      unless params[:building].blank?
        conditions << '(address.building LIKE :building OR address.house LIKE :building)'
        values[:building] = "%#{params[:building].strip.to_geo}%"
        join_address = true
      end
      unless params[:flate].blank?
        conditions << 'address.flate LIKE :flate'
        values[:flate] = "%#{params[:flate].strip.to_geo}%"
        join_address = true
      end
    end
    rel = Bs::Customer
    rel = rel.joins('INNER JOIN bs.address ON customer.premisekey = address.premisekey') if join_address
    rel = rel.joins('INNER JOIN bs.region ON address.regionkey = region.regionkey') if join_regions
    rel = rel.joins('INNER JOIN bs.street ON address.streetkey = street.streetkey') if join_address
    rel.where(conditions.join(' AND '), values).paginate(per_page: 15, page: page).order(:accnumb)
  end

  def validate_last_task(cust)
    lastTask = Call::Task.where(custkey: cust.custkey).last
    if lastTask && (lastTask.created_at + Call::REPEAT) > Time.now
      redirect_to call_customer_tasks_url(custkey: cust.custkey), alert: 'არ შეიძლება ახალი დავალების დამატება: ამ აბონენტზე დავალება ეს წუთია გაცემულია!!!'
      false
    else
      true
    end
  end

end
