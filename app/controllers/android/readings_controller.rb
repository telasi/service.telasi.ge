# -*- encoding : utf-8 -*-
class Android::ReadingsController < ApplicationController

  # რეესტრის მიღება.
  def reester
    process_login do
      date = Date.strptime params[:date], '%d-%b-%Y' unless params[:date].blank?
      @route = Bs::RouteStoreHeader.where(cycledate: date, inspectorid: @user.bs_person).first
      unless @route
        @message = "რეესტრი ვერ მოიძებნა."
        render partial: 'android/readings/error'
      end
    end
  end

  private

  def process_login
    @user = User.authenticate_bs(params[:username], params[:password])
    if @user
      yield if block_given?
    else
      @message = 'არასწორი მომხმარებელი ან პაროლი.'
      render partial: 'android/readings/error'
    end
  end

end
