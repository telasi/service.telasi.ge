# -*- encoding : utf-8 -*-
class Call::TasksController < ApplicationController

  def index
    @title = 'დავალებები'
    @tasks = Call::Task.by_user(current_user).desc(:_id).paginate(per_page: 20, page: params[:page])
    navbuttons
  end

  private

  def navbuttons
    @nav = { 'მთავარი' => call_home_url }
    @nav['ყველა დავალება'] = nil
  end

end
