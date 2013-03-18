# -*- encoding : utf-8 -*-
class Call::MainController < ApplicationController

  def index
    @title = 'ქოლ-ცენტრი'
    @tasks = Call::Task.by_user(current_user).where(complete: false).desc(:_id).paginate(per_page: 10, page: params[:page])
    @favorites = Call::Task.by_user(current_user).where(:_id.in => (current_user.favorite_task_ids || [])).desc(:_id)
    @stats = Call::Status.asc(:order_by)
  end

  def add_favorite
    ary = current_user.favorite_task_ids || []
    unless ary.include?(params[:id])
      ary << params[:id]
      current_user.favorite_task_ids = ary
      current_user.save
    end
    redirect_to call_home_url, notice: 'დამატებულია ფავორიტებში'
  end

  def remove_favorite
    ary = current_user.favorite_task_ids || []
    ary.delete params[:id]
    current_user.favorite_task_ids = ary
    current_user.save
    redirect_to call_home_url, notice: 'წაშლილია ფავორიტებიდან'
  end

end
