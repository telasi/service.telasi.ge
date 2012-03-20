# -*- encoding : utf-8 -*-

class SiteController < ApplicationController

  def index
    @title = 'საწყისი'
  end

  def help
    @title = 'დახმარება'
  end

  def login
    @title = 'შესვლა'
    if request.post?
      user = User.authenticate(params[:email], params[:password])
      if user.nil?
        @error = 'არასწორი მომხმარებელი ან პაროლი.'
      elsif not user.email_confirmed
        @error = 'ეს ანგარიში დაუდასტურებელია'
      else
        session[:user_id] = user.id
        redirect_to home_url
      end
    end
  end

  def logout
    session[:user_id] = nil
    redirect_to home_url
  end

  def register
    if params[:status] == 'ok'
      @show_success = true
      @title = 'რეგისტრაცია წარმატებულია'
    else
      @title = 'რეგისტრაცია'
      if request.post?
        @user = User.new(params[:user])
        if @user.save
          redirect_to(register_url(:status => :ok), :notice => 'მომხმარებელი შექმნილია') if @user.save
          UserMailer.email_confirmation(@user).deliver
        end
      else
        @user = User.new
      end
    end
  end

end
