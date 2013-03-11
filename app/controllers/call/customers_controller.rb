# -*- encoding : utf-8 -*-
class Call::CustomersController < ApplicationController

  def index
    @title = 'აბონენტების ძებნა'
    if params[:accnumb]
      @customer = Bs::Customer.where(accnumb: params[:accnumb].to_geo).first
      redirect_to call_customer_info_url(custkey: @customer.custkey) if @customer
    end
  end

  def customer_info
    @title = 'მონაცემები აბონენტზე'
    @customer = Bs::Customer.where(custkey: params[:custkey]).first
    @customer_form = CustomerForm.customer_form(@customer)
    @trash_customer_form = TrashCustomerForm.customer_form(@customer.trash_customer)
    @trash_customer_form.collapsed = true
    @water_customer_form = WaterCustomerForm.customer_form(@customer)
    @water_customer_form.collapsed = true
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
    @cuts = Bs::CutHistory.where(custkey: params[:custkey]).order('OPER_DATE desc').paginate(page: params[:page], per_page: 20)
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

end
