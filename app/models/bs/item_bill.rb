# -*- encoding : utf-8 -*-
class Bs::ItemBill < ActiveRecord::Base
  self.table_name  = 'bs.item_bill'
  self.primary_key = :itemkey
  belongs_to :customer, class_name: 'Bs::Customer', foreign_key: :custkey
end
