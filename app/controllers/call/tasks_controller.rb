# -*- encoding : utf-8 -*-
class Call::TasksController < ApplicationController

  def index
    @title = 'დავალებები'
    operators = User.where(call_center: true, all_regions: true).asc(:first_name, :last_name)
    regions = Ext::Region.all
    @search = TaskForm.search(operators, regions, params[:dim])
    @tasks = search_tasks(params[:dim]).desc(:_id).paginate(per_page: 15, page: params[:page])
    navbuttons
  end

  private

  def search_tasks(opts)
    cust = Bs::Customer.where(accnumb: opts[:accnumb].strip.to_geo).first rescue nil
    stat = Call::Status.find(opts[:status]) rescue nil
    reg  = Ext::Region.find(opts[:region]) rescue nil
    oper = User.find(opts[:user]) rescue nil
    tasks = Call::Task.by_user(current_user)
    tasks = tasks.where(custkey: cust.custkey) if cust
    tasks = tasks.where(status_id: stat.id) if stat
    tasks = tasks.where(region_id: reg.id) if reg
    tasks = tasks.where(user_id: oper.id) if oper
    tasks
  end

  def navbuttons
    @nav = { 'მთავარი' => call_home_url }
    @nav['ყველა დავალება'] = nil
  end

end
