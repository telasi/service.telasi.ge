# -*- encoding : utf-8 -*-
class Bs::Street < ActiveRecord::Base
  self.table_name  = 'bs.street'
  self.primary_key = :streetkey
end
