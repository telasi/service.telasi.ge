# -*- encoding : utf-8 -*-
class Bs::CutHistory < ActiveRecord::Base
  include Bs::CutBase
  self.table_name  = 'bs.cut_history' #'dimitri.ruby_cut_history'
  self.set_integer_columns :mark_code, :oper_code
end
