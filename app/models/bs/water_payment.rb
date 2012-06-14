# -*- encoding : utf-8 -*-
class Bs::WaterPayment < ActiveRecord::Base
  self.table_name  = 'paymentsadmin.payments_gwp'
  self.primary_key = :opayment_id
  belongs_to :customer, class_name: 'Bs::Customer', foreign_key: :custkey
end
