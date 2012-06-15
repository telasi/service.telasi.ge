# -*- encoding : utf-8 -*-
class DebtController < ApplicationController

  # საწყისი გვერდი.
  def index
    @title = 'აბონენტის დავალიანება'
    unless params[:accnumb].blank?
      accnumb = params[:accnumb].to_geo
      @customer = Bs::Customer.where(accnumb: accnumb).first
      @not_found = true unless @customer
    end
  end

  # აბონენტის დამატება.
  def add_customer
    cust = current_user.customers.where(accnumb: params[:accnumb]).first
    unless cust
      bs_cust = Bs::Customer.where(accnumb: params[:accnumb].to_geo).first
      cust = UserCustomer.new(user: current_user, custkey: bs_cust.custkey, custname: bs_cust.custname.to_ka, accnumb: bs_cust.accnumb.to_ka)
      cust.save
    end
    redirect_to debt_url(accnumb: params[:accnumb]), notice: 'აბონენტი დამატებულია'
  end

  # აბონენტის წაშლა.
  def remove_customer
    #current_user.accnumbs.delete(params[:accnumb])
    #current_user.save
    redirect_to debt_url(accnumb: params[:accnumb]), notice: 'აბონენტი წაშლილია'
  end

end
