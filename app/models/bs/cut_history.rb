# -*- encoding : utf-8 -*-
class Bs::CutHistory < ActiveRecord::Base
  include Bs::CutBase

  UPLOAD_STATUS_OPERATOR = 1
  UPLOAD_STATUS_INSPECTOR = 2
  UPLOAD_STATUS_GNERC = 3

  self.table_name  = 'bs.cut_history' #'dimitri.ruby_cut_history'
  self.set_integer_columns :mark_code, :oper_code, :mark_code_insp, :upload_status
end
