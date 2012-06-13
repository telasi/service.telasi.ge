# -*- encoding : utf-8 -*-
class Bs::TrashCustomer < ActiveRecord::Base
  self.table_name  = 'trashcustomer'
  self.primary_key = :trashcustkey
  belongs_to :customer, class_name: 'Bs::Customer', foreign_key: :custkey
end
