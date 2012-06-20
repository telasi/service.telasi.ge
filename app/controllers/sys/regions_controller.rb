# -*- encoding : utf-8 -*-
class Sys::RegionsController < ApplicationController

  # რეგიონების სია.
  def index
    @title = 'რეგიონები'
    @regions = Ext::Region.asc(:regionkey)
  end

  # მდებარეობის დადგენა.
  def region
    @title = 'მდებარეობა'
    @region = Ext::Region.find(params[:id])
  end

  # მდებარეობის შეცვლა.
  def set_location
    region = Ext::Region.find(params[:id])
    region.latitude = params[:lat];
    region.longitude = params[:lng];
    region.save
    render text: 'ok'
  end

  # რეგიონის სინქრონიზაცია.
  def sync_regions
    Ext::Region.sync
    redirect_to sys_regions_path, notice: 'რეგიონები სინქრონიზებულია.'
  end

  # შეცვლა.
  def edit
    @title = 'რეგიონის შეცვლა'
    @region = Ext::Region.find(params[:id])
    if request.put?
      redirect_to sys_region_url if @region.update_attributes(params[:ext_region])
    end
  end

end
