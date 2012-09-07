# -*- encoding : utf-8 -*-
class Android::AndroidController < ApplicationController

  def index
    @title = 'Android'
  end

  def users
    @title = 'მომხმარებლები'
    @users = User.excludes(bs_person: nil)
  end

  def reester
    #date = Date.strptime '1-Jun-2012', '%d-%b-%Y'
    #inspector = 11795
    date = Date.strptime params[:date], '%d-%b-%Y' unless params[:date].blank?
    inspector = params[:inspector]
    @route = Bs::RouteStoreHeader.where(cycledate: date, inspectorid: inspector).first
  end

end
