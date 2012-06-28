# -*- encoding : utf-8 -*-
class Gis::Transformator < ActiveRecord::Base
  self.inheritance_column = nil
  self.table_name = 'mv_dispetch.mv_tr_pnt'
  self.primary_key = :objectid
end
