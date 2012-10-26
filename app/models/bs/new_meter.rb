# -*- encoding : utf-8 -*-
class Bs::NewMeter < ActiveRecord::Base
  self.table_name  = 'bs.new_meters'
  self.primary_key = :meter_number
end
