# -*- encoding : utf-8 -*-
class MagtiController < ApplicationController

  def index
    msg_90033(params[:from], params[:text]) if params[:service_id] == '90033'
    render text: "ok"
  end

  private

  # message @90033
  def msg_90033(from, text)
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
    end
  end

  def find_accnumb_in_text(text)
    indx1 = text.downcase.index('abon: ') + 6
    indx2 = text.downcase[indx1..-1].index(' ') + indx1 - 1
    text[indx1..indx2]
  end

end
