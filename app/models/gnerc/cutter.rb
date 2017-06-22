# -*- encoding : utf-8 -*-
class Gnerc::Cutter < ActiveRecord::Base
  self.table_name  = 'semek.cutter'
  self.primary_key = 'id'

  self.set_integer_columns :mainaccount
end
