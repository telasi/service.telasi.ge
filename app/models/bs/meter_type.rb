# -*- encoding : utf-8 -*-
class Bs::MeterType < ActiveRecord::Base
  self.table_name  = 'bs.mttype'
  self.primary_key = :mttpkey

  def without_meter?
    self.mttpkey == 15
  end
end
