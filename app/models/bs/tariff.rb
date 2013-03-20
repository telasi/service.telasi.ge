# -*- encoding : utf-8 -*-
class Bs::Tariff < ActiveRecord::Base
  self.table_name  = 'bs.tarcomp'
  self.primary_key = :compkey
end