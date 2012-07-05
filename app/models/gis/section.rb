# -*- encoding : utf-8 -*-
class Gis::Section < ActiveRecord::Base
  self.inheritance_column = nil
  self.table_name = 'mv_dispetch.hv_section_ln'
  self.primary_key = :objectid
end
