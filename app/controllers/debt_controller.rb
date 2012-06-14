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
    current_user.accnumbs = [] unless current_user.accnumbs
    current_user.accnumbs << params[:accnumb] unless current_user.accnumbs.include?(params[:accnumb])
    current_user.save
    redirect_to debt_url(accnumb: params[:accnumb]), notice: 'აბონენტი დამატებულია'
  end

  # აბონენტის წაშლა.
  def remove_customer
    current_user.accnumbs.delete(params[:accnumb])
    current_user.save
    redirect_to debt_url(accnumb: params[:accnumb]), notice: 'აბონენტი წაშლილია'
  end

end
