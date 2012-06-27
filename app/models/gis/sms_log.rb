# -*- encoding : utf-8 -*-
class Gis::SmsLog < ActiveRecord::Base
  self.inheritance_column = nil if Rails.env.development?
  self.table_name = 'mv_dispetch.sms_log'
  self.primary_key = :sms_log_id

  def self.sync
    # TODO: synchronize
  end

end
