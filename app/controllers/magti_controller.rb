# -*- encoding : utf-8 -*-
class MagtiController < ApplicationController
  # Incomming sms messages.
  def index
    if !params[:from].nil?
       sender_mob_v = params[:from].to_s
       if sender_mob_v[0] == '+'
         sender_mob_v = sender_mob_v[1..12]
       end

      sender_mob_v.strip!

      incmsg = Sms::Message.new
      incmsg.company = 'MAGTI' 
      incmsg.sender_mobile = sender_mob_v
      incmsg.smsid = params[:message_id]   
      incmsg.text = params[:text]
      incmsg.receiver_mobile = params[:service_id]
      incmsg.recieved_at = Time.now
      incmsg.save
    end

    if params[:service_id] == '90033'
      msg_90033(params[:from], params[:text])
    end
    render text: "ok"
  end

  def send_sms
    Magti.send_sms(params[:mobile], params[:message][0..150].to_lat) if Magti::SEND
    render text: "ok"
  rescue Exception => ex
    render text: ex.message
  end

  private

  def msg_90033(from, text)
    # return if process_dispatch(from, text)
    return if process_sms_on_off(from, text)
    return if process_callcenter(from, text)
  end

  # def process_dispatch(from,text)
  #   if Telasi::DISPATCHER_ADMINS.include?(from)
  #     if Magti::SEND
  #       # Telasi::PHONES_1.each do |phone|
  #       Telasi::PHONES_1_1.each do |phone,locale|
  #         Magti.send_sms(phone,text)
  #       end
  #     end
  #     true
  #   else
  #     false
  #   end
  # end

  def process_sms_on_off(from, text)
    if text.blank? || text.strip.length < 6
      mobile = from[-9..-1]
      customer_mobiles = Bs::CustomerMobile.where(mobile: mobile)
      if customer_mobiles.any?
        customer_mobiles.each do |customer_mobile|
          customer_mobile.update_attributes(status: 0)
        end
        return true
      end
    elsif text.length > 5
      customer = Bs::Customer.where(accnumb: text.strip).first
      if customer
        mobile = from[-9..-1]
        customer_mobile = Bs::CustomerMobile.where(mobile: mobile,  custkey: customer.custkey).first
        customer_mobile = Bs::CustomerMobile.create(mobile: mobile, custkey: customer.custkey, is_main: 0) if customer_mobile.blank?
        customer_mobile.update_attributes(status: 1)
        return true
      end
    end

    false
  end

  def process_callcenter(from, text)
    accnumb = find_accnumb_in_text(text) rescue nil
    if accnumb
      customer = Bs::Customer.where(accnumb: accnumb).first
      user = User.where(sys_admin: true).first
      stat = Call::Status.where(complete: true).first
      open_ids = Call::Status.where(open: true).each.map{ |s| s.id }
      Call::Task.where(custkey: customer.custkey, :status_id.in => open_ids).each do |t|
        if t.status != stat
          Call::TaskComment.new(text: "[SMS: #{from}] დავალება შესრულებულია", task: t, user: user).save
          t.status = stat
          t.save
        end
      end
      true
    else
      false
    end
  end

  def find_accnumb_in_text(text)
    begin
      indx1 = text.downcase.index('abon:') + 5
      indx2 = text.downcase[indx1..-1].index(' ') + indx1 - 1
      text[indx1..indx2]
    rescue
      nil
    end
  end
end
