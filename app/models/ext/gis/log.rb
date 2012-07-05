# -*- encoding : utf-8 -*-
class Ext::Gis::Log
  include Mongoid::Document
  include Mongoid::Timestamps

  STATUS_FOR_SENT = 0
  STATUS_SENT_CANCELED = 1
  STATUS_SENT = 2

  TRANSFORMATOR = 'mv_tr_pnt'

  field :log_id, type: Integer
  field :table_name, type: String
  field :objectid, type: Integer
  field :gis_status, type: Integer
  field :username, type: String
  field :log_date, type: DateTime
  field :sms_status, type: Integer

  belongs_to :pair, class_name: 'Ext::Gis::Log'
  belongs_to :message, class_name: 'Ext::Gis::Message', inverse_of: :logs

  index :log_id
  index :objectid

  def transformator?
    self.table_name = Ext::Gis::Log::TRANSFORMATOR
  end

  def object
    if transformator?
      Ext::Gis::Transformator.where(objectid: self.objectid).first
    end
  end

  def enabled?
    self.gis_status == 1
  end

  def date
    self.log_date - Gis::CORR
  end

end