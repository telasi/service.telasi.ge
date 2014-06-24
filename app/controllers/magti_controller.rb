# -*- encoding : utf-8 -*-
class MagtiController < ApplicationController

  def index
    msg_90033(params[:from], params[:text]) if params[:service_id] == '90033'
    render text: "ok"
  end

  def send_sms
    Magti.send_sms(params[:mobile], params[:message][0..150].to_lat) if Magti::SEND
    render text: "ok"
  rescue Exception => ex
    render text: ex.message
  end

  private

  # message @90033
  def msg_90033(from, text)
    return if process_dispatch(from, text)
    return if process_callcenter(from, text)
  end

  def process_dispatch(from,text)
    if Telasi::DISPATCHER_ADMINS.include?(from)
      if Magti::SEND
        # Telasi::PHONES_3.each do |phone|
        Telasi::PHONES_3_1.each do |phone,locale|
          Magti.send_sms(phone,text)
        end
      end
      true
    else
      false
    end
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
    indx1 = text.downcase.index('abon:') + 5
    indx2 = text.downcase[indx1..-1].index(' ') + indx1 - 1
    text[indx1..indx2]
  end
end
