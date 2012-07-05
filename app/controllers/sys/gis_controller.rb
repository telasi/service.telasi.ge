# -*- encoding : utf-8 -*-
class Sys::GisController < ApplicationController

# ქსელის ობიექტები.

  def transformators
    @title = 'ტრანსფორმატორები'
    rel = Ext::Gis::Transformator
    session[:gis_tr_filter] = params[:filter] if params[:filter]
    rel = rel.where(acckey: nil) if session[:gis_tr_filter] == 'problem'
    @transformators = rel.asc(:tp_name, :tr_name).paginate(page: params[:page], per_page: 10)
  end

  def sync_transformators
    Ext::Gis::Transformator.sync
    redirect_to sys_transformators_url, notice: 'სინქრონიზაცია დასრულებულია.'
  end

  def sync_transformator
    trans = Ext::Gis::Transformator.find(params[:id])
    trans.sync
    trans.save
    redirect_to sys_transformators_url(page: params[:page]), notice: 'სინქრონიზაცია დასრულებულია.'
  end

  def sections
    @title = 'სექციები'
  end

  def sync_stations
    Ext::Gis::Section.sync
    redirect_to sys_stations_url, notice: 'სინქრონიზაცია დასრულებულია.'
  end

# ლოგების მართვა.

  def logs
    @title = 'ლოგები'
    @logs = Ext::Gis::Log.desc(:log_id).paginate(page: params[:page], per_page: 10)
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

  def edit_receiver
    @title = 'მიმღების შეცვლა'
    @receiver = Gis::Receiver.find(params[:id])
    if request.put?
      redirect_to sys_gis_receivers_url, notice: 'მიმღები განახლებულია.' if @receiver.update_attributes(params[:gis_receiver])
    end
  end

  def delete_receiver
    receiver = Gis::Receiver.find(params[:id])
    receiver.destroy
    redirect_to sys_gis_receivers_url, notice: 'მიმღები წაშლილია.'
  end

# შეტყობინებები.

  def messages
    @title = 'შეტყობინებების რეესტრი'
    @messages = Ext::Gis::Message.desc(:created_at).paginate(page: params[:page], per_page: 10)
  end

  def message
    @title = 'შეტყობინების დეტალები'
    @message = Ext::Gis::Message.find(params[:id])
  end

  def send_message
    @message = Ext::Gis::Message.find(params[:id])
    Gis::Receiver.where(active: true).each do |r|
      mobile = @message.on ? r.mobile_on : r.mobile_off
      Magti.send_sms(mobile, @message.sms_text)  if Magti::SEND and mobile 
    end
    redirect_to sys_gis_message_url(id: @message.id), notice: 'შეტყობინება გაგზავნილია.'
  end

# აბონენტების, ქუჩების და ბიზნეს-ცენტრების სია.

  def details
    @relations = Bs::Accrel.where(base_acckey: params[:tpid])
    @transformator = Ext::Gis::Transformator.where(acckey: params[:tpid]).first
    @streets = []
    @relations.each do |rel|
      address = rel.account.address
      street = address.street
      region = address.region
      @streets.push(street) unless @streets.include?(street)
    end
    render partial: 'sys/gis/details'
  end

end
