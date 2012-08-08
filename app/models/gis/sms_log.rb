# -*- encoding : utf-8 -*-
class Gis::SmsLog < ActiveRecord::Base
  self.inheritance_column = nil
  self.table_name = 'mv_dispetch.sms_log'
  self.primary_key = :sms_log_id

  def self.sync
    Gis::SmsLog.sync_new_logs
    Gis::SmsLog.pair_logs
    Gis::SmsLog.send_messages
  end

  private

  def self.sync_new_logs
    last_id = Ext::Gis::Log.max(:log_id) || 0
    l_date = Date.today - 1
    tables = [Ext::Gis::Log::SECTION, Ext::Gis::Log::FIDER, Ext::Gis::Log::TRANSFORMATOR]
    Gis::SmsLog.where('table_name IN (?) AND sms_log_id > ? AND enter_date > ?', tables, last_id, l_date).each do |l|
      Ext::Gis::Log.new(log_id: l.sms_log_id, table_name: l.table_name, objectid: l.oid,
        gis_status: l.status, gis_off_status: (l.off_status || 0),
        username: l.user_name, log_date: l.enter_date,
        sms_status: Ext::Gis::Log::STATUS_FOR_SENT).save
    end
  end

  def self.pair_logs
    Ext::Gis::Log.where(sms_status: Ext::Gis::Log::STATUS_FOR_SENT).desc(:log_id).each do |log|
      log.reload
      if log.sms_status == Ext::Gis::Log::STATUS_FOR_SENT
        pair = Ext::Gis::Log.where(objectid: log.objectid, :_id.ne => log.id,
          :sms_status => Ext::Gis::Log::STATUS_FOR_SENT, :log_date.gte => (log.log_date - Gis::DIFF),
          :table_name => log.table_name
        ).first
        if pair and pair.enabled? != log.enabled?
          # log
          log.pair = pair
          log.sms_status = Ext::Gis::Log::STATUS_SENT_CANCELED
          log.save
          # pair
          pair.pair = log
          pair.sms_status = Ext::Gis::Log::STATUS_SENT_CANCELED
          pair.save
        end
      end
    end
  end

  def self.send_messages
    send_on_message
    send_off_message_of_type(0)
    send_off_message_of_type(Ext::Gis::Log::OFF_STATUS_DAMAGE)
    send_off_message_of_type(Ext::Gis::Log::OFF_STATUS_PLANED)
    send_off_message_of_type(Ext::Gis::Log::OFF_STATUS_MAINTN)
    send_off_message_of_type(Ext::Gis::Log::OFF_STATUS_SWITCH)
    send_off_message_of_type(Ext::Gis::Log::OFF_STATUS_FIRE)
    send_off_message_of_type(Ext::Gis::Log::OFF_STATUS_CORRECTION)
    send_off_message_of_type(Ext::Gis::Log::OFF_STATUS_DEBT)
  end

  def self.send_on_message
    on  = Ext::Gis::Message.create(on: true, off_status: 0)
    Ext::Gis::Log.where(sms_status: Ext::Gis::Log::STATUS_FOR_SENT).asc(:log_id).each do |log|
      if log.enabled? and log.log_date < (Time.now + Gis::CORR - Gis::DIFF)
        log.message =  on
        log.sms_status = Ext::Gis::Log::STATUS_SENT
        log.save
      end
    end
    on.reload.sync
    if on.reload.logs.empty?
      on.destroy
    else
      Gis::Receiver.send_message(on)
    end
  end

  def self.send_off_message_of_type(type)
    off = Ext::Gis::Message.create(on: false, off_status: type)
    Ext::Gis::Log.where(sms_status: Ext::Gis::Log::STATUS_FOR_SENT, gis_off_status: type).asc(:log_id).each do |log|
      if not log.enabled? and log.log_date < (Time.now + Gis::CORR - Gis::DIFF)
        log.message = off
        log.sms_status = Ext::Gis::Log::STATUS_SENT
        log.save
      end
    end
    off.reload.sync
    if off.reload.logs.empty?
      off.destroy
    else
      Gis::Receiver.send_message(off)
    end
  end

end
