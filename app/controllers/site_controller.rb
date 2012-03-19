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
  end

  def register
    @title = 'რეგისტრაცია'
    if request.post?
      @user = User.new(params[:user])
      @user.save!
      redirect_to(login_url, :notice => 'მომხმარებელი შექმნილია') 
    else
      @user = User.new
    end
    
  end
end

