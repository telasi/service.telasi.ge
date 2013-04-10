# -*- encoding : utf-8 -*-
class Call::CutHistory::Okrosubani < ActiveRecord::Base
  include Bs::CutBase
  self.table_name = 'ruby_cut_history_okrosubani'
  self.set_integer_columns :mark_code, :oper_code
end
