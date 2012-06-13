# -*- encoding : utf-8 -*-
class Bs::Customer < ActiveRecord::Base
  self.table_name  = 'customer'
  self.primary_key = :custkey
  has_one :trash_customer, class_name: 'Bs::TrashCustomer', foreign_key: :custkey
  belongs_to :address, class_name: 'Bs::Address', foreign_key: :premisekey
end
