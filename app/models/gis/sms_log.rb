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
    Gis::SmsLog.where('table_name IN (?) AND sms_log_id > ?', [Ext::Gis::Log::SECTION, Ext::Gis::Log::FIDER, Ext::Gis::Log::TRANSFORMATOR], last_id).each do |l|
      Ext::Gis::Log.new(log_id: l.sms_log_id, table_name: l.table_name, objectid: l.oid,
        gis_status: l.status, username: l.user_name, log_date: l.enter_date,
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
    Gis::SmsLog.send_message_table(Ext::Gis::Log::SECTION)
    Gis::SmsLog.send_message_table(Ext::Gis::Log::FIDER)
    Gis::SmsLog.send_message_table(Ext::Gis::Log::TRANSFORMATOR)
  end

  def self.send_message_table(tbl)
    on  = Ext::Gis::Message.create(on: true, table_name: tbl)
    off = Ext::Gis::Message.create(on: false, table_name: tbl)
    Ext::Gis::Log.where(sms_status: Ext::Gis::Log::STATUS_FOR_SENT, table_name: tbl).asc(:log_id).each do |log|
      if log.log_date < (Time.now + Gis::CORR - Gis::DIFF)
        log.message    = log.enabled? ? on : off
        log.sms_status = Ext::Gis::Log::STATUS_SENT
        log.save
      end
    end
    on.reload.sync
    off.reload.sync
    on.destroy  if on.reload.logs.empty?
    off.destroy if off.reload.logs.empty?
  end

end
