# -*- encoding : utf-8 -*-
class CustomerController < ApplicationController

  # საწყისი გვერდი.
  def index
    @title = 'აბონენტის დავალიანება'
    unless params[:accnumb].blank?
      accnumb = params[:accnumb].to_geo
      @customer = Bs::Customer.where(accnumb: accnumb).first
      if @customer
        @region = Ext::Region.where(regionkey: @customer.address.region.regionkey).first
      else
        @not_found = true
      end
    end
  end

  # აბონენტის დამატება.
  def add_customer
    cust = current_user.customers.where(accnumb: params[:accnumb]).first
    unless cust
      bs_cust = Bs::Customer.where(accnumb: params[:accnumb].to_geo).first
      cust = UserCustomer.new(user: current_user, custkey: bs_cust.custkey, custname: bs_cust.custname.to_ka, accnumb: bs_cust.accnumb.to_ka)
      cust.last_balance       = bs_cust.normal_balance
      cust.last_trash_balance = bs_cust.normal_trash_balance
      cust.last_water_balance = bs_cust.normal_water_balance
      cust.save
    end
    redirect_to debt_url(accnumb: params[:accnumb]), notice: 'აბონენტი დამატებულია'
  end

  # აბონენტის წაშლა.
  def remove_customer
    cust = current_user.customers.where(accnumb: params[:accnumb]).first
    cust.destroy if cust
    redirect_to debt_url(accnumb: params[:accnumb]), notice: 'აბონენტი წაშლილია'
  end

  # აბონენტის ისტორია.
  def history
    @title = 'აბონენტის ისტორია'
    @customer = Bs::Customer.where(accnumb: params[:accnumb]).first
    @pre_payment = @customer.pre_payment
    @items = Bs::Item.where(custkey: @customer.custkey).order('itemkey DESC').paginate(page: params[:page], per_page: 10)
  end

  # აბონენტის ისტორიის ერთი კონკრეტული ამონაწერი.
  def item
    @title = 'ოპერაციის დეტალები'
    @customer = Bs::Customer.where(accnumb: params[:accnumb]).first
    @item = Bs::Item.where(custkey: @customer.custkey, itemkey: params[:itemkey]).first
    @prev = Bs::Item.where('custkey = ? and itemkey < ?', @customer.custkey, params[:itemkey]).order('itemkey desc').first
    @next = Bs::Item.where('custkey = ? and itemkey > ?', @customer.custkey, params[:itemkey]).order('itemkey asc').first
  end

  # აბონენტის დასუფთავების ისტორია.
  def trash_history
    @title = 'დასუფთავების ისტორია'
    @customer = Bs::Customer.where(accnumb: params[:accnumb]).first
    @items = Bs::TrashItem.where(custkey: @customer.custkey).order('trashitemid DESC').paginate(page: params[:page], per_page: 10)
  end

end
