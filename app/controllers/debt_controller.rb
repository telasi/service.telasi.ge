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

end
