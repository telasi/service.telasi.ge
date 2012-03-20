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
    if params[:status] == 'ok'
      @show_success = true
      @title = 'რეგისტრაცია წარმატებულია'
    else
      @title = 'რეგისტრაცია'
      if request.post?
        @user = User.new(params[:user])
        redirect_to(register_url(:status => :ok), :notice => 'მომხმარებელი შექმნილია') if @user.save
      else
        @user = User.new
      end
    end
  end
end
