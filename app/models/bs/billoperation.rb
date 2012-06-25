# -*- encoding : utf-8 -*-
class Bs::Billoperation < ActiveRecord::Base
  self.table_name  = 'bs.billoperation'
  self.primary_key = :billoperkey

  def ext_operation
    Ext::Billoperation.where(billoperkey: self.billoperkey).first
  end
end
