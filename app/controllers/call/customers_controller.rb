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
  end

  def items
    @title = 'აბონენტის ისტორია'
    @customer = Bs::Customer.where(custkey: params[:custkey]).first
    @items = Bs::Item.where(custkey: @customer.custkey).order('ITEMKEY desc').paginate(page: params[:page], per_page: 20)
  end

  def item
    @title = 'ოპერაციის დეტალები'
    @item = Bs::Item.where(itemkey: params[:itemkey]).first
    @customer = @item.customer
    @account = @item.account
  end

end
