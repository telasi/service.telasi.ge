# -*- encoding : utf-8 -*-
class ApplicationController < ActionController::Base
  protect_from_forgery

  # აბრუნებს მიმდინარე მომხმარებელს.
  def current_user
    unless @__user_initialized
      begin
        @__user = User.find(session[:user_id])
      rescue Exception => ex
      end if session[:user_id]
      @__user_initialized = true
    end
    @__user
  end

end
