# -*- encoding : utf-8 -*-
class Sys::GisController < ApplicationController

  def transformators
    @title = 'ტრანსფორმატორები'
    rel = Ext::Transformator
    rel = rel.where(acckey: nil) if params[:filter] == 'problem'
    @transformators = rel.asc(:tp_name, :tr_name)
  end

  def sync_transformators
    Ext::Transformator.sync
    redirect_to sys_transformators_url, notice: 'სინქრონიზაცია დასრულებულია.'
  end

  def logs
    @title = 'ლოგები'
  end

end
