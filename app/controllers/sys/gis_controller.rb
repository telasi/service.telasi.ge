# -*- encoding : utf-8 -*-
class Sys::GisController < ApplicationController

# ტრანსპფორმატორების მართვა.

  def transformators
    @title = 'ტრანსფორმატორები'
    rel = Ext::Transformator
    session[:gis_tr_filter] = params[:filter] if params[:filter]
    rel = rel.where(acckey: nil) if session[:gis_tr_filter] == 'problem'
    @transformators = rel.asc(:tp_name, :tr_name).paginate(page: params[:page], per_page: 10)
  end

  def sync_transformators
    Ext::Transformator.sync
    redirect_to sys_transformators_url, notice: 'სინქრონიზაცია დასრულებულია.'
  end

  def sync_transformator
    Ext::Transformator.find(params[:id]).sync
    redirect_to sys_transformators_url(page: params[:page]), notice: 'სინქრონიზაცია დასრულებულია.'
  end

# ლოგების მართვა.

  def logs
    @title = 'ლოგები'
    @logs = Ext::GisLog.desc(:log_id).paginate(page: params[:page], per_page: 10)
  end

  def sync_logs
    Gis::SmsLog.sync
    redirect_to sys_gis_logs_url, notice: 'სინქრონიზაცია დასრულებულია.'
  end

# მიმღებთა სიის მართვა.

  def receivers
    @title = 'დაგზავნის პარამეტრები'
    @receivers = Gis::Receiver.asc(:name)
  end

  def new_receiver
    @title = 'ახალი მიმღები'
    if request.post?
      @receiver = Gis::Receiver.new(params[:gis_receiver])
      redirect_to sys_gis_receivers_url, notice: 'მიმღები შექმნილია.' if @receiver.save
    else
      @receiver = Gis::Receiver.new(active: true)
    end
  end

end
