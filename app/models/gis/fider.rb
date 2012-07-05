# -*- encoding : utf-8 -*-
class Gis::Fider < ActiveRecord::Base
  self.inheritance_column = nil
  self.table_name = 'mv_dispetch.hv_fiderswitches_pnt'
  self.primary_key = :objectid
end
