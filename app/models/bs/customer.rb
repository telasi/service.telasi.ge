# -*- encoding : utf-8 -*-
class Bs::Customer < ActiveRecord::Base
  self.table_name  = 'bs.customer'
  self.primary_key = :custkey
  belongs_to :address, class_name: 'Bs::Address', foreign_key: :premisekey
  has_one  :trash_customer, class_name: 'Bs::TrashCustomer', foreign_key: :custkey
  has_many :water_items,    class_name: 'Bs::WaterItem',     foreign_key: :custkey, order: 'year, month'
end
