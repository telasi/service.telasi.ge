# -*- encoding : utf-8 -*-
class Call::TasksController < Call::CallController

  def index
    @title = 'დავალებები'
    @search = params[:search] == 'clear' ? {} : params[:search]
    rel = Call::Task.by_user(current_user)
    if @search
      customer = Bs::Customer.where(accnumb: @search[:accnumb].strip.to_geo).first rescue nil
      rel = rel.where(custkey: customer.custkey) if customer
      rel = rel.where(category_id: @search[:category_id]) if @search[:category_id].present?
      rel = rel.where(status_id: @search[:status_id]) if @search[:status_id].present?
      rel = rel.where(user_id: @search[:user_id]) if @search[:user_id].present?
      rel = rel.where(region_id: @search[:region_id]) if @search[:region_id].present?
      d1 = Date.strptime(@search[:d1]) if @search[:d1].present?
      d2 = Date.strptime(@search[:d2]) if @search[:d2].present?
      rel = rel.where(:created_at.gte => d1) if d1.present?
      rel = rel.where(:created_at.lte => d2 + 1) if d2.present?
    end
    @tasks = rel.desc(:_id).paginate(per_page: 15, page: params[:page])
    navbuttons
  end

  private

  def navbuttons
    @nav = { 'მთავარი' => call_home_url }
    @nav['ყველა დავალება'] = nil
  end
end
