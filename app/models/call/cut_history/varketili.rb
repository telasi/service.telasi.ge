# -*- encoding : utf-8 -*-
class Call::CutHistory::Varketili < ActiveRecord::Base
  include Bs::CutBase
  self.table_name = 'ruby_cut_history_varketili'
  self.set_integer_columns :mark_code, :oper_code
end
