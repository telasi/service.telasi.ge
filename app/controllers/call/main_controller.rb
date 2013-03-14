# -*- encoding : utf-8 -*-
class Call::MainController < ApplicationController
  include Dima::Html
  include Rails.application.routes.url_helpers

  def index
    @title = 'ქოლ-ცენტრი'

    @tasks = Call::Task.by_user(current_user).where(complete: false).desc(:_id).paginate(per_page: 10, page: params[:page])
    @favorites = Call::Task.by_user(current_user).where(:_id.in => current_user.favorite_task_ids).desc(:_id)

    @task_table = TaskForm.task_table(@tasks)
    @task_table.item_actions.clear
    add_url = lambda{ |v| call_add_to_favorites_path(id: v.id) }
    @task_table.item_actions << Action.new(icon: '/assets/fff/heart_add.png', tooltip: 'ფავორიტებში დამატება', url: add_url, method: 'post')
    @task_table.title = 'შეუსრულებელი დავალებები'

    @favorites_table = TaskForm.task_table(@favorites)
    @favorites_table.item_actions.clear
    remove_url = lambda{ |v| call_remove_from_favorites_path(id: v.id) }
    @favorites_table.item_actions << Action.new(icon: '/assets/fff/heart_delete.png', tooltip: 'ფავორიტებში წაშლა', url: remove_url, method: 'delete')
    @favorites_table.title = 'ფავორიტები'
    @favorites_table.icon = '/assets/fff/heart.png'
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
