# -*- encoding : utf-8 -*-
class Sys::UsersController < ApplicationController

  # მომხმარებლების საწყისი გვერდი.
  def index
    @q = params[:q]
    @title = 'მომხმარებლები'
    @users = User.by_q(@q).desc(:created_at).paginate(page: params[:page], per_page: 5)
    render :json => {:q => @q, :d => render_to_string(:partial => 'sys/users/list')} if request.xhr?
  end

  # მომხმარებლის რედაქტირება.
  def edit
    @title = 'მომხმარებლის რედაქტირება'
    @user = User.where(_id: params[:id]).first
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

end
