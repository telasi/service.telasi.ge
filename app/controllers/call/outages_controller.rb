# -*- encoding : utf-8 -*-
class Call::OutagesController < Call::CallController
  def index
    @title = 'გათიშვები'
    @outages = Call::Outage.where(active: true).desc(:_id)
    navbuttons
  end

  def new
    @title = 'ახალი გათიშვა'
    if request.post?
      @outage = Call::Outage.new(params[:call_outage])
      if @outage.save
        # TODO:
      end
    else
      @outage = Call::Outage.new
    end
    navbuttons
  end

  private

  def navbuttons
    @nav = { 'მთავარი' => call_home_url, 'გათიშვები' => call_outages_url }
    @nav[@title] = nil if @outage
  end
end