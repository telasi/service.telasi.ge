# -*- encoding : utf-8 -*-
class Bs::Discrecstatusdet < ActiveRecord::Base
  self.table_name  = 'bs.discrecstatus_det' 
  self.primary_key = :discrecstatus_det_key
  self.set_integer_columns :status, :discrecstatus_det_key

  belongs_to :discrecstatus, class_name: 'Bs::Discrecstatus', foreign_key: :discrecstatuskey
end