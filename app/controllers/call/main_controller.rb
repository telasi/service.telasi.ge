# -*- encoding : utf-8 -*-
class Call::MainController < Call::CallController

  def index
    @title = 'ქოლ-ცენტრი'
    respond_to do |format|
      format.html do
        @tasks = open_tasks.desc(:_id).paginate(per_page: 10, page: params[:page])
        @outage = Call::Outage.find(params[:id]) if params[:id].present?
      end
      format.xlsx{ @tasks = open_tasks.desc(:_id) }
    end
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
    open_tasks.each { |task| task.sync(current_user) }
    redirect_to call_home_url, notice: 'სინქრონიზაცია დასრულებულია.'
  end

  def all
    @search = params[:search] == 'clear' ? {} : params[:search]
    rel = Call::Task.by_user(current_user)
    if @search
     if !@search[:accnumb].present? && @search[:mtnumb].present?
      mtnumb = Bs::Account.where(mtnumb: @search[:mtnumb]).first 
      customer = Bs::Customer.where(custkey: mtnumb.custkey).first rescue nil
     else
      customer = Bs::Customer.where(accnumb: @search[:accnumb].strip.to_geo).first rescue nil
     end 

      rel = rel.where(custkey: customer.custkey) if customer
      rel = rel.where(category_id: @search[:category_id]) if @search[:category_id].present?
      rel = rel.where(status_id: @search[:status_id]) if @search[:status_id].present?
      rel = rel.where(user_id: @search[:user_id]) if @search[:user_id].present?
      rel = rel.where(region_id: @search[:region_id]) if @search[:region_id].present?
      if @search[:d1].present?
        d1str = "#{@search[:d1]} #{@search[:t1].present? ? @search[:t1] : '00:00'}"
        d1 = Time.strptime(d1str, '%Y-%m-%d %H:%M')
        rel = rel.where(:created_at.gte => d1)
      end
      if @search[:d2].present?
        d2str = "#{@search[:d2]} #{@search[:t2].present? ? @search[:t2] : '24:00'}"
        d2 = Time.strptime(d2str, '%Y-%m-%d %H:%M')
        rel = rel.where(:created_at.lte => d2)
      end
    end
    respond_to do |format|
      format.html do
        @title = 'დავალებები'
        @tasks = rel.desc(:_id).paginate(per_page: 15, page: params[:page])
        navbuttons
      end
      format.xlsx do
        @tasks = rel.desc(:_id).paginate(per_page: 1000)
        render action: 'index'
      end
    end
  end

  private

  def open_tasks
    open_stats = Call::Status.where(open: true)
    Call::Task.by_user(current_user).where(:status_id.in => open_stats.map{|v| v.id})
  end

  def navbuttons
    @nav = { 'მთავარი' => call_home_url }
    @nav['ყველა დავალება'] = nil
  end
end
