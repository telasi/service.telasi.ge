# -*- encoding : utf-8 -*-
class Sys::UsersController < ApplicationController
  before_filter :admin_validation

  # მომხმარებლების საწყისი გვერდი.
  def index
    @q = params[:q]
    @title = 'მომხმარებლები'
    @users = User.by_q(@q).desc(:created_at).paginate(page: params[:page], per_page: 10)
    render :json => {:q => @q, :d => render_to_string(:partial => 'sys/users/list')} if request.xhr?
  end

  # მომხმარებლის რედაქტირება.
  def edit
    @title = 'მომხმარებლის რედაქტირება'
    @user = User.where(_id: params[:id]).first
    @regions = Ext::Region.asc(:name)
    if request.put?
      redirect_to sys_users_path, notice: 'მომხმარებელი შეცვლილია.' if @user.update_attributes(params[:user]) 
    end
  end

  # მომხმარებლის წაშლა.
  def delete
    user = User.where(_id: params[:id]).first
    user.delete
    redirect_to sys_users_path, notice: 'მომხმარებელი წაშლილია.'
  end

  # show user properties
  def show
    @title = 'მომხმარებელის თვისებები'
    @user = User.find(params[:id])
  end

  def confirm_acc
    user = User.find(params[:id])
    user.accnumbs.delete(params[:accnumb])
    user.confirmed_accnumbs ||= []
    user.confirmed_accnumbs << params[:accnumb]
    user.save
    redirect_to sys_show_user_url(id: user.id), notice: 'ანგარიში დადასტურებულია.'
  end

  def remove_acc
    user = User.find(params[:id])
    user.confirmed_accnumbs.delete(params[:accnumb])
    user.accnumbs ||= []
    user.accnumbs << params[:accnumb]
    user.save
    redirect_to sys_show_user_url(id: user.id), notice: 'ანგარიში გაუქმებულია.'
  end
private

  def admin_validation
    user = current_user
    if user.nil?
      session[:return_url] = request.url
      redirect_to login_url, notice: 'გაიარეთ ავტორიზაცია.'
    elsif !user.sys_admin
      redirect_to login_url, notice: 'არ გაქვთ შესვლის უფლება.'
    end
  end
end
