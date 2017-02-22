# -*- encoding : utf-8 -*-
class Bs::Payment < ActiveRecord::Base
  self.table_name  = 'payments.payment'
  self.primary_key = :paykey
  self.set_integer_columns :status
  belongs_to :customer, class_name: 'Bs::Customer', foreign_key: :custkey
end
