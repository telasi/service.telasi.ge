# -*- encoding : utf-8 -*-
class Bs::CustomerMobile < ActiveRecord::Base
  self.table_name  = 'bs.customer_mobile'
  self.primary_keys = [:custkey, :mobile]
  belongs_to :customer, class_name: 'Bs::Customer', foreign_key: :custkey
end
