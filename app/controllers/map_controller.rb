# -*- encoding : utf-8 -*-
class MapController < ApplicationController

  # რუკა.
  def index
    @title = 'ბიზნეს-ცენტრების რუკა'
    @regions = Ext::Region.where(show_on_map: true).asc(:regionkey)
  end

end
