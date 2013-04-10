# -*- encoding : utf-8 -*-
class Call::CutHistory::Chugureti < ActiveRecord::Base
  include Bs::CutBase
  self.table_name = 'ruby_cut_history_chugureti'
  self.set_integer_columns :mark_code, :oper_code
end
