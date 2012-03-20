# -*- encoding : utf-8 -*-

class SiteController < ApplicationController
  def index
    unless current_user
      @title = 'საწყისი'
    else
      @title = 'განცხადებები'
      @applications = Application.where(:owner_id => current_user.id)
      render 'applications/index'
    end
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
          (Telasi::USE_DELAYED_JOB ? UserMailer.delay : UserMailer).email_confirmation(@user).deliver if @user.email_confirm_hash
        end
      else
        @user = User.new
      end
    end
  end

  def confirm
    begin
      @user = User.find(params[:id])
      @title = 'რეგისტრაციის დადასტურება'
      if @user.email_confirm_hash == params[:hash]
        @user.email_confirm_hash = nil
        @user.email_confirmed = true
        @user.save!
        @confirmed = true
      else
        @confirmed = false
      end
    rescue Exception => ex
      @error = ex.to_s
    end
  end

  def account
    @title = 'ანგარიშის მართვა'
    @user = current_user
    if request.put?
      redirect_to home_url, :notice => 'თქვენი ანგარიში განახლებულია' if @user.update_attributes(params[:user])
    end
  end

  def change_password
    @title = 'პაროლის შეცვლა'
    @user = current_user
    if request.put?
      redirect_to home_url, :notice => 'პაროლი შეცვლილია' if @user.update_attributes(params[:user])
    end
  end

end
