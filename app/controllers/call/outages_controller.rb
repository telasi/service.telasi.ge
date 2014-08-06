# -*- encoding : utf-8 -*-
class Call::OutagesController < Call::CallController
  def index
    @title = 'გათიშვები'
    @outages = Call::Outage.where(active: true).desc(:_id)
    navbuttons
  end

  private

  def navbuttons
    @nav = { 'მთავარი' => call_home_url, 'გათიშვები' => call_outages_url }
  end
end