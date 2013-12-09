# -*- encoding : utf-8 -*-
class Ext::Gis::Log
  include Mongoid::Document
  include Mongoid::Timestamps

  STATUS_FOR_SENT = 0
  STATUS_SENT_CANCELED = 1
  STATUS_SENT = 2

  OFF_STATUS_DAMAGE       = 1  # ავარია
  OFF_STATUS_SWITCH       = 2  # გადართვა
  OFF_STATUS_PLANED       = 3  # გეგმიური
  OFF_STATUS_MAINTN       = 4  # პროფილაკტიკა
  OFF_STATUS_CORRECTION   = 5  # სქემის კორექცია
  OFF_STATUS_FIRE         = 6  # ხანძარი
  OFF_STATUS_DEBT         = 7  # დავალიანებით
  OFF_STATUS_EXPLOITATION = 8  # ექსპლუატაციის მოთხოვნით
  OFF_STATUS_RESERVATION  = 9  # სარეზერვო
  OFF_STATUS_SECTIONOFF   = 10 # სექციის გამორთვა

  SECTION = 'hv_section_ln'
  FIDER = 'hv_fiderswitches_pnt'
  TRANSFORMATOR = 'mv_tr_pnt'

  field :log_id, type: Integer
  field :table_name, type: String
  field :objectid, type: Integer
  field :gis_status, type: Integer
  field :gis_off_status, type: Integer
  field :username, type: String
  field :log_date, type: DateTime
  field :sms_status, type: Integer

  belongs_to :pair, class_name: 'Ext::Gis::Log'
  belongs_to :message, class_name: 'Ext::Gis::Message', inverse_of: :logs

  index({ log_id: 1 })
  index({ objectid: 1 })

  def self.off_status_text(off_status, locale = nil)
    I18n.t("gis_off_status_#{off_status || 0}", locale: (locale || I18n.locale)) unless off_status.blank? or off_status == 0
  end

  def call_center_icon; self.enabled? ? "/assets/fff/accept.png" : "/assets/fff/cancel.png" end
  def call_center_text; self.enabled? ?  "ჩართულია" : "გათიშვა: #{Ext::Gis::Log.off_status_text(self.gis_off_status)}" end
  def section?; self.table_name == Ext::Gis::Log::SECTION end
  def fider?; self.table_name == Ext::Gis::Log::FIDER end
  def transformator?; self.table_name == Ext::Gis::Log::TRANSFORMATOR end
  def enabled?; self.gis_status == 1 end
  def date; self.log_date - Gis::CORR end

  def object
    if section?
      rel = Ext::Gis::Section
    elsif fider?
      rel = Ext::Gis::Fider
    elsif transformator?
      rel = Ext::Gis::Transformator
    end
    rel.where(objectid: self.objectid).first
  end
end
