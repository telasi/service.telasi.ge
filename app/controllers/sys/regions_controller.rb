# -*- encoding : utf-8 -*-
class Sys::RegionsController < ApplicationController

  # რეგიონების სია.
  def index
    @title = 'რეგიონები'
    @regions = Ext::Region.asc(:regionkey)
  end

  # რეგიონის სინქრონიზაცია.
  def sync
    Ext::Region.sync
    redirect_to sys_regions_path, notice: 'რეგიონები სინქრონიზებულია.'
  end

  # მდებარეობის დადგენა.
  def location
    @title = 'მდებარეობა'
    @region = Ext::Region.find(params[:id])
  end

end
