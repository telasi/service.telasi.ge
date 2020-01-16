# -*- encoding : utf-8 -*-
class Gnerc::CutterTest < ActiveRecord::Base
  self.table_name  = 'temo.cutter'
  self.primary_key = 'id'

  self.set_integer_columns :mainaccount
end
