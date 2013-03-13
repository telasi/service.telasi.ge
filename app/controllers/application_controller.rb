# -*- encoding : utf-8 -*-
require 'securerandom'

class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_locale

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

  def auth_token
    session[:_csrf_token] ||= SecureRandom.base64(32)
  end

  protected

  def set_locale
    session[:locale] = params[:locale] unless params[:locale].blank?
    I18n.locale = session[:locale] || 'ka'
  end

  def validate_login
    unless current_user
      session[:return_url] = request.url
      redirect_to login_url, alert: 'აღნიშნული მოქმედების შესასრულებლად საჭიროა ავტორიზაცია.'
    end
  end

end
