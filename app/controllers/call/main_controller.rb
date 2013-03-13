# -*- encoding : utf-8 -*-
class Call::MainController < ApplicationController

  def index
    @title = 'ქოლ-ცენტრი'
    @tasks = Call::Task.where(complete: false).desc(:_id).paginate(per_page: 10, page: params[:page])
    @task_table = TaskForm.task_table(@tasks)
    @task_table.item_actions.clear
    @task_table.title = 'შეუსრულებელი დავალებები'
  end

end
