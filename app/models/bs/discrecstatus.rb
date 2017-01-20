# -*- encoding : utf-8 -*-
class Bs::Discrecstatus < ActiveRecord::Base
  self.table_name  = 'bs.discrecstatus'
  self.primary_key = :discrecstatuskey
  self.set_integer_columns :status_type

  has_many :det, class_name: 'Bs::Discrecstatusdet', foreign_key: :discrecstatuskey

  def self.cutter_statuses
  	Bs::Discrecstatus.where("STATUSTYPE IN (?)", [0, 1])
  end
end
