# -*- encoding : utf-8 -*-
class Gis::Station < ActiveRecord::Base
  self.inheritance_column = nil
  self.table_name = 'mv_dispetch.hv_fider_ln'
  self.primary_key = :objectid
end
