# -*- encoding : utf-8 -*-
class UsersController < ApplicationController

  # მომხმარებლის ავტორიზაცია.
  def login
    @title = 'სისტემაში შესვლა'
    if request.post?
      user = User.authenticate(params[:email], params[:password])
      if user.nil?
        flash.now[:alert] = 'არასწორი მომხმარებელი ან პაროლი.'
      elsif not user.email_confirmed
        flash.now[:alert] = 'ელ. ფოსტა არაა დადასტურებული.'
      else
        session[:user_id] = user.id
        redirect_to home_url
      end
    end
  end

  # სისტემიდან გასვლა.
  def logout
    session[:user_id] = nil
    redirect_to home_url
  end

  # ახალი მომხმარებლის რეგისტრაცია.
  def register
    if params[:status] == 'ok'
      @show_success = true
      @title = 'რეგისტრაცია წარმატებულია'
    else
      @title = 'რეგისტრაცია'
      if request.post?
        @user = User.new(params[:user])
        if @user.save
          redirect_to register_url(:status => :ok) if @user.save
          UserMailer.email_confirmation(@user).deliver if @user.email_confirm_hash
        end
      else
        @user = User.new
      end
    end
  end

  # მომხმარებლის ელ. ფოსტის დადასტურება.
  def confirm
  	@title = 'ელ. ფოსტის დადასტურება'
  	user = User.where(:_id => params[:id]).first
  	if user and user.email_confirm_hash == params[:c]
  		user.email_confirmed = true
  		user.email_confirm_hash = nil
  		user.save
  		@confirmed = true
  	else
  		@confirmed = false
  	end
  end

  # მომხმარებლის ანგარიშის მართვა.
  def account
    @title = 'ანგარიშის მართვა'
    @user = current_user
    if request.put?
      redirect_to home_url, :notice => 'თქვენი ანგარიში განახლებულია.' if @user.update_attributes(params[:user])
    end
  end

  # მომხმარებლის ფოტოსურათი.
  def photo
  	@title = 'ფოტოს შეცვლა'
  	@user = current_user
  	if request.put?
      redirect_to home_url, :notice => 'თქვენი გამოსახულება შეცვლილია.' if @user.update_attributes(params[:user])
    end
  end

  # პაროლის შეცვლა.
  def change_password
    @title = 'პაროლის შეცვლა'
    @user = current_user
    if request.put?
      redirect_to home_url, :notice => 'პაროლი შეცვლილია' if @user.update_attributes(params[:user])
    end
  end

  # პაროლის აღდგენა.
  def restore
  	@title = 'პაროლის აღდგენა'
  	if request.post?
  		user = User.where(:email => params[:email]).first
  		if user
  			UserMailer.restore_password(user).deliver
  		else
  			flash.now[:alert] = 'ასეთი მომხმარებელი ვერ მოიძებნა.'
  		end
  	end
  end

end

