# -*- encoding : utf-8 -*-
class Gis::SmsLog < ActiveRecord::Base
  self.inheritance_column = nil if Rails.env.development?
  self.table_name = 'mv_dispetch.sms_log'
  self.primary_key = :sms_log_id

  def self.sync
    last_id = Ext::GisLog.max(:log_id) || 0
    Gis::SmsLog.where('table_name = ? AND sms_log_id > ?', 'mv_tr_pnt', last_id).each do |glog|
      Ext::GisLog.new(log_id: glog.sms_log_id, table_name: glog.table_name, objectid: glog.objectid,
        gis_status: glog.status, username: glog.user_name, log_date: glog.enter_date,
        sms_status: Ext::GisLog::STATUS_FOR_SENT).save
    end
  end

end
