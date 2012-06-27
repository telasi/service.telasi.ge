# -*- encoding : utf-8 -*-
class Sys::GisController < ApplicationController

  def transformators
    @title = 'ტრანსფორმატორები'
    @transformators = Ext::Transformator.asc(:tp_name, :tr_name)
  end

  def sync_transformators
    Ext::Transformator.sync
    redirect_to sys_transformators_url, notice: 'სინქრონიზაცია დასრულებულია.'
  end

end
