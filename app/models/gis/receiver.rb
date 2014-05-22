# -*- encoding : utf-8 -*-
class Gis::Receiver
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name,       type: String
  field :active,     type: Boolean
  field :locale,     type: String, default: 'ka'
  field :email_on,   type: String
  field :email_off,  type: String
  field :mobile_on,  type: String
  field :mobile_off, type: String
  index({ name: 1 })

  def self.send_message(msg)
    return if msg.transformator_count == 0
    Gis::Receiver.where(active: true).each do |r|
      mobile = msg.on ? r.mobile_on : r.mobile_off
      email  = msg.on ? r.email_on  : r.email_off
      #Magti.send_sms(mobile, msg.sms_text(r.locale == 'ru' ? 'en' : r.locale).to_lat) if Magti::SEND and (not mobile.blank?)
      Magti.send_sms(mobile, msg.sms_text(r.locale).to_lat) if Magti::SEND and (not mobile.blank?)
      begin
        subject = "TELASI: #{ msg.sms_text(r.locale) }"
        body = msg.email_text(r.locale)
        Pony.mail(:from => "Telasi.ge <support@telasi.ge>", to: email, html_body: body, subject: subject)
      rescue Exception => ex
      end unless email.blank?
      msg.sent= true
      msg.save
    end
  end

end
