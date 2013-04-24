# -*- encoding : utf-8 -*-
class Call::MainController < Call::CallController

  def index
    @title = 'ქოლ-ცენტრი'
    @tasks = open_tasks.desc(:_id).paginate(per_page: 10, page: params[:page])
    #@favorites = Call::Task.by_user(current_user).where(:_id.in => (current_user.favorite_task_ids || [])).desc(:_id)
    #@stats = Call::Status.asc(:order_by)
    #@mobiles = Call::RegionData.asc(:_id)
  end

  def print_tasks
    @title = 'ბეჭდვა'
    open_stats = Call::Status.where(open: true)
    @tasks = Call::Task.by_user(current_user).where(:status_id.in => open_stats.map{|v| v.id}).desc(:_id)
    render layout: 'print'
  end

  def complete_task
    task = Call::Task.by_user(current_user).where(_id: params[:id]).first
    task.status = Call::Status.where(complete: true).first
    task.save
    comment = Call::TaskComment.new(user: current_user, task: task, text: '[ავტომატური ტექსტი] სწრაფი დახურვა')
    comment.save
    redirect_to call_home_url, notice: 'დავალება დახურულია'
  end

  def sync_tasks
    open_tasks.each do |task|
      task.sync(current_user)
    end
    redirect_to call_home_url, notice: 'სინქრონიზაცია დასრულებულია.'
  end

  private

  def open_tasks
    open_stats = Call::Status.where(open: true)
    Call::Task.by_user(current_user).where(:status_id.in => open_stats.map{|v| v.id})
  end
  
end
