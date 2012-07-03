# -*- encoding : utf-8 -*-
class Gis::SmsLog < ActiveRecord::Base
  self.inheritance_column = nil
  self.table_name = 'mv_dispetch.sms_log'
  self.primary_key = :sms_log_id

  DIFF = 5.minutes

  def self.sync
    Gis::SmsLog.sync_new_logs
    Gis::SmsLog.pair_logs
    Gis::SmsLog.send_messages
  end

  private

  def self.sync_new_logs
    last_id = Ext::GisLog.max(:log_id) || 0
    Gis::SmsLog.where('table_name = ? AND sms_log_id > ?', Ext::GisLog::TRANSFORMATOR, last_id).each do |glog|
      Ext::GisLog.new(log_id: glog.sms_log_id, table_name: glog.table_name, objectid: glog.objectid,
        gis_status: glog.status, username: glog.user_name, log_date: glog.enter_date,
        sms_status: Ext::GisLog::STATUS_FOR_SENT).save
    end
  end

  def self.pair_logs
    Ext::GisLog.where(sms_status: Ext::GisLog::STATUS_FOR_SENT).desc(:log_id).each do |log|
      log.reload
      if log.sms_status == Ext::GisLog::STATUS_FOR_SENT
        pair = Ext::GisLog.where(objectid: log.objectid, :_id.ne => log.id,
          :sms_status => Ext::GisLog::STATUS_FOR_SENT, :log_date.gte => (log.log_date - DIFF)).first
        if pair and pair.enabled? != log.enabled?
          # log
          log.pair = pair
          log.sms_status = Ext::GisLog::STATUS_SENT_CANCELED
          log.save
          # pair
          pair.pair = log
          pair.sms_status = Ext::GisLog::STATUS_SENT_CANCELED
          pair.save
        end
      end
    end
  end

  def self.send_messages
     on = Ext::GisMessage.create(on: true)
    off = Ext::GisMessage.create(on: false)
    Ext::GisLog.where(sms_status: Ext::GisLog::STATUS_FOR_SENT).asc(:log_id).each do |log|
      if log.created_at < (Time.now - DIFF)
        if log.enabled?
          log.message = on
        else
          log.message = off
        end
        log.sms_status = Ext::GisLog::STATUS_SENT
        log.save
      end
    end
    on.destroy if on.reload.logs.empty?
    off.destroy if off.reload.logs.empty?
  end

end
