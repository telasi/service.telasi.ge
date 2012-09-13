# -*- encoding : utf-8 -*-
class Android::ReadingsController < ApplicationController

  include Android::BsLoginController

  # რეესტრის გაგზავნა.
  def reester
    process_login do
      date = Date.strptime params[:date], '%d-%b-%Y' unless params[:date].blank?
      @route = Bs::RouteStoreHeader.where(cycledate: date, inspectorid: @user.bs_person).first
      unless @route
        @message = "რეესტრი ვერ მოიძებნა."
        render partial: 'android/readings/error'
      else
        @route.download_count += 1
        @route.save
      end
    end
  end

  def upload
    # TODO:
  end

end
