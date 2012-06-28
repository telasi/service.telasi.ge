# -*- encoding : utf-8 -*-
class Ext::GisLog
  include Mongoid::Document
  include Mongoid::Timestamps

  STATUS_FOR_SENT = 0
  STATUS_SENT_CANCELED = 1
  STATUS_SENT = 2

  field :log_id, type: Integer
  field :table_name, type: String
  field :objectid, type: Integer
  field :gis_status, type: Integer
  field :username, type: String
  field :log_date, type: DateTime
  field :sms_status, type: Integer

  index :log_id
  index :objectid

  def object
    if self.table_name = 'mv_tr_pnt'
      Ext::Transformator.where(objectid: self.objectid).first
    end
  end

  def enabled?
    self.gis_status == 1
  end

end
