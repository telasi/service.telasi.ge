# -*- encoding : utf-8 -*-
class Bs::TrashPayment < ActiveRecord::Base
  self.table_name  = 'payments.trashpayment'
  self.primary_key = :paykey
  self.set_integer_columns :status
  belongs_to :customer, class_name: 'Bs::Customer', foreign_key: :custkey
end
