# -*- encoding : utf-8 -*-
class Sys::GisController < ApplicationController
  before_filter :gis_validation

  private

  def gis_validation
    user = current_user
    if user.nil?
      session[:return_url] = request.url
      redirect_to login_url, notice: 'გაიარეთ ავტორიზაცია.'
    elsif !can_view?(user)
      redirect_to login_url, notice: 'არ გაქვთ შესვლის უფლება.'
    end
  end

  def can_view?(user)
    if ['messages', 'message', 'details', 'logs'].include?(self.action_name) and user.has_role?([:sys_admin, :gis_viewer])
      true
    elsif user.has_role?([:sys_admin])
      true
    else
      false
    end
  end

  public

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
    @sections = Ext::Gis::Section.asc(:station, :voltage, :number).paginate(page: params[:page], per_page: 10)
  end

  def sync_sections
    Ext::Gis::Section.sync
    redirect_to sys_sections_url, notice: 'სინქრონიზაცია დასრულებულია.'
  end

  def fiders
    @title = 'ფიდერები'
    @fiders = Ext::Gis::Fider.asc(:station, :voltage, :section_number, :number).paginate(page: params[:page], per_page: 10)
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
    @q = params[:q] || session[:gismsg_q]
    p = params[:page] || session[:gismsg_p]
    session[:gismsg_q] = @q
    session[:gismsg_p] = p
    @title = 'შეტყობინებების რეესტრი'
    @messages = Ext::Gis::Message.by_q(@q).desc(:created_at, :_id).paginate(page: p, per_page: 10)
    @messages = Ext::Gis::Message.by_q(@q).desc(:created_at, :_id).paginate(page: 1, per_page: 10) if (@messages.empty? and p.to_i > 1)
    render :json => {:q => @q, :d => render_to_string(:partial => 'sys/gis/message_list')} if request.xhr?
  end

  def message
    @title = 'შეტყობინების დეტალები'
    @message = Ext::Gis::Message.find(params[:id])
    @next = Ext::Gis::Message.where(:created_at.gte => @message.created_at, :_id.gt => @message.id).asc(:created_at, :_id).first
    @prev = Ext::Gis::Message.where(:created_at.lte => @message.created_at, :_id.lt => @message.id).desc(:created_at, :_id).first
  end

  def send_message
    msg = Ext::Gis::Message.find(params[:id])
    Gis::Receiver.send_message(msg)
    redirect_to sys_gis_message_url(id: msg.id), notice: 'შეტყობინება გაგზავნილია.'
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
