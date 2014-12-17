# -*- encoding : utf-8 -*-
class Sys::GisController < ApplicationController
  before_filter :gis_validation

  def gis_menu_items
    items = { 'GIS' => sys_gis_url }
    case action_name
    when 'messages' then items['შეტყობინებები'] = sys_gis_messages_url
    when 'message' then items['შეტყობინებები'] = sys_gis_messages_url and items[@title] = nil
    when 'new_receiver', 'edit_receiver'
      items['დაგზავნის სია'] = sys_gis_receivers_url
      items[@title] = nil
    when 'summary_receivers', 'new_summary_receiver', 'edit_summary_receiver'
      items['დაგზავნის სია (შემაჯამებელი)'] = sys_gis_summary_receivers_url
      items[@title] = nil
    else items[@title] = nil
    end
    items
  end
  helper_method :gis_menu_items

  def index; @title = 'GIS' end

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
    @title = 'დაგზავნის სია'
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

# summary_receivers

  def summary_receivers
    @title = 'დაგზავნის სია (შემაჯამებელი)'
    @receivers = Gis::SummaryReceiver.active.asc(:name)
  end

  def new_summary_receiver
    @title = 'ახალი მიმღები'
    if request.post?
      @receiver = Gis::SummaryReceiver.new(params[:gis_summary_receiver])
      if @receiver.save
        redirect_to sys_gis_summary_receivers_url, notice: 'მიმღები შექმნილია'
      end
    else
      @receiver = Gis::SummaryReceiver.new
    end
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

# რეპორტები

  def tp_statuses
    @title = 'TP-ს სტატუსები'
    @d1 = Time.strptime("#{params[:d1]} #{params[:t1] || '00:00'}", '%d-%b-%Y %H:%M') rescue Date.today
    @d2 = Time.strptime("#{params[:d2]} #{params[:t2] || '00:00'}", '%d-%b-%Y %H:%M') rescue (Date.today + 1)
    map = %Q{
      function() {
        var result = { on: 0, off: 0, unknown: 0, damage: 0, switch: 0, planed: 0, maintain: 0, correction: 0, fire: 0, debt: 0, explotation: 0, reservation: 0 };
        if (this.gis_status == 1) {
          result.on = 1;
          emit(this.objectid, result);
        } else {
          result.off = 1;
          if      ( this.gis_off_status == 1 ) { result.damage      = 1; }
          else if ( this.gis_off_status == 2 ) { result.switch      = 1; }
          else if ( this.gis_off_status == 3 ) { result.planed      = 1; }
          else if ( this.gis_off_status == 4 ) { result.maintain    = 1; }
          else if ( this.gis_off_status == 5 ) { result.correction  = 1; }
          else if ( this.gis_off_status == 6 ) { result.fire        = 1; }
          else if ( this.gis_off_status == 7 ) { result.debt        = 1; }
          else if ( this.gis_off_status == 8 ) { result.explotation = 1; }
          else if ( this.gis_off_status == 9 ) { result.reservation = 1; }
          else                                 { result.unknown     = 1; }
          emit(this.objectid, result);
        }
      }
    }
    reduce = %Q{
      function(key, values) {
        var result = { on: 0, off: 0, unknown: 0, damage: 0, switch: 0, planed: 0, maintain: 0, correction: 0, fire: 0, debt: 0, explotation: 0, reservation: 0 };
        values.forEach(function(value) {
          result.on += value.on;
          result.off += value.off;
          result.damage += value.damage;
          result.switch += value.switch;
          result.planed += value.planed;
          result.maintain += value.maintain;
          result.correction += value.correction;
          result.fire += value.fire;
          result.debt += value.debt;
          result.explotation += value.explotation;
          result.reservation += value.reservation;
        });
        return result;
      }
    }
    t1 = @d1 + 4.hours # bug in log's date!
    t2 = @d2 + 4.hours # bug in log's date!
    data = Ext::Gis::Log.where(sms_status: Ext::Gis::Log::STATUS_SENT, :table_name => 'mv_tr_pnt', :log_date.gte => t1, :log_date.lte => t2).map_reduce(map, reduce).out(inline: true)
    @items = []
    @summary = { on: 0, off: 0, damage: 0, switch: 0, planed: 0, maintain: 0, correction: 0,
      fire: 0, debt: 0, explotation: 0, reservation: 0,unknown: 0 }
    data.each do |row|
      value = row['value']
      transf = Ext::Gis::Transformator.where(objectid: row['_id'].to_i).first
      if transf # and value['on']
        @items << {
          tp: transf.tp_name, tr: transf.tr_name,
          transformator: "#{transf.tp_name}-#{transf.tr_name}",
          on: value['on'].to_i, off: value['off'].to_i,
          damage: value['damage'].to_i, switch: value['switch'].to_i,
          planed: value['planed'].to_i, maintain: value['maintain'].to_i,
          correction: value['correction'].to_i, fire: value['fire'].to_i,
          debt: value['debt'].to_i, explotation: value['explotation'].to_i,
          reservation: value['reservation'].to_i,
          unknown: value['unknown'].to_i
        }
        @summary[:on] += value['on'].to_i
        @summary[:off] += value['off'].to_i
        @summary[:damage] += value['damage'].to_i
        @summary[:switch] += value['switch'].to_i
        @summary[:planed] += value['planed'].to_i
        @summary[:maintain] += value['maintain'].to_i
        @summary[:correction] += value['correction'].to_i
        @summary[:fire] += value['fire'].to_i
        @summary[:debt] += value['debt'].to_i
        @summary[:explotation] += value['explotation'].to_i
        @summary[:reservation] += value['reservation'].to_i
        @summary[:unknown] += value['unknown'].to_i
      end
    end
  end

### Network status

  def network_status
    @title = 'ქსელის მდგომარეობა'
    @transformators = Ext::Gis::Transformator.where(on: false, :off_status.ne => 0).asc(:tp_name, :tr_name)
  end

  def network_status_sync
    #Ext::Gis::Transformator.sync_current_status
    Ext::Gis::Transformator.sync_current_status_and_prepare_report
    redirect_to sys_gis_network_status_url, notice: 'სინქრონიზაცია დასრულებულია.'
  end

  def network_status_edit
    @title='SMS შეცვლა'
    @reports=Ext::Gis::TransformatorReport.all.to_a
    if request.post?
      (0..params[:size].to_i-1).each do |i|
        r = @reports[i]
        r.count1 = params["count1-#{i}".to_sym]
        r.count2 = params["count2-#{i}".to_sym]
        r.save
      end
      redirect_to sys_gis_network_status_url, notice: 'მონაცემები შეცვლილია'
    end
  end

  def network_status_send
    if Ext::Gis::TransformatorReport.where(sent: true).any?
      raise "უკვე გაგზავნილია!"
    else
      # Ext::Gis::Transformator.send_current_status(1, true)
      Ext::Gis::Transformator.send_current_status(4, true) # TEST group
      redirect_to sys_gis_network_status_url, notice: 'გაგზავნილია'
    end
  end

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
    gis_actions=['index', 'messages', 'message', 'details', 'logs', 'tp_statuses', 'network_status', 'network_status_sync', 'network_status_edit', 'network_status_send']
    if gis_actions.include?(self.action_name) and user.has_role?([:sys_admin, :gis_viewer]) then true
    elsif user.has_role?([:sys_admin]) then true
    else false end
  end
end
