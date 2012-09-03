# -*- encoding : utf-8 -*-
class Android::ReadingsController < ApplicationController

  def reester
    #date = Date.strptime '1-Jun-2012', '%d-%b-%Y'
    #inspector = 11795
    date = Date.strptime params[:date], '%d-%b-%Y' unless params[:date].blank?
    inspector = params[:inspector]
    @route = Bs::RouteStoreHeader.where(cycledate: date, inspectorid: inspector).first
  end

end
