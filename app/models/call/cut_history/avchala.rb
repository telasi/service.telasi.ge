# -*- encoding : utf-8 -*-
class Call::CutHistory::Avchala < ActiveRecord::Base
  include Bs::CutBase
  self.table_name = 'ruby_cut_history_avchala'
  self.set_integer_columns :mark_code, :oper_code
end
