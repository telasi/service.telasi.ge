# -*- encoding : utf-8 -*-
class Bs::TrashItem < ActiveRecord::Base
  self.table_name  = 'bs.trashitem'
  self.primary_key = :trashitemkey
  belongs_to :customer,  class_name: 'Bs::Customer', foreign_key: :custkey
  belongs_to :operation, class_name: 'Bs::Trashoperation', foreign_key: :operationid
end
