# -*- encoding : utf-8 -*-
class Call::CustomersController < ApplicationController

  def index
    @title = 'აბონენტების ძებნა'
    if params[:accnumb]
      @customer = Bs::Customer.where(accnumb: params[:accnumb].to_geo).first
      redirect_to call_customer_info_url(id: @customer.custkey) if @customer
    end
  end

  def customer_info
    @title = 'მონაცემები აბონენტზე'
    @customer = Bs::Customer.where(custkey: params[:id]).first
  end

end
