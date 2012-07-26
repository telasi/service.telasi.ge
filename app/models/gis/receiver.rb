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
  index :name

  def ru?
    self.locale == 'ru'
  end

  def self.send_message(msg)
    return if msg.transformator_count == 0
    Gis::Receiver.where(active: true).each do |r|
      mobile = msg.on ? r.mobile_on : r.mobile_off
      email  = msg.on ? r.email_on  : r.email_off
      Magti.send_sms(mobile, msg.sms_text) if Magti::SEND and (not mobile.blank?)
      begin
        subject = "TELASI: #{ r.ru? ? msg.sms_text(true) : msg.sms_text }"
        body = %Q{<!DOCTYPE html>
          <html>
            <head><meta http-equiv="content-type" content="text/html; charset=utf-8" /></head>
            <body>
              <p>#{r.ru? ? msg.sms_text(true) : msg.sms_text.to_ka(true)}</p>
              #{r.ru? ? %Q{<p>Дополнительную информацию смотрите <a href="http://service.telasi.ge/sys/gis/message/#{msg.id.to_s}">на сайте</a>.</p>} : %Q{<p>დამატებითი ინფორმაციის მისაღებად მიჰყევით <a href="http://service.telasi.ge/sys/gis/message/#{msg.id.to_s}">ბმულს</a>.</p>}}
            </body>
          </html>}
        Pony.mail(:from => "Telasi.ge <support@telasi.ge>", to: email, html_body: body, subject: subject)
      rescue Exception => ex
      end unless email.blank?
      msg.sent= true
      msg.save
    end
  end

end
