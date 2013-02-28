# -*- encoding : utf-8 -*-
class Bs::TrashCustomer < ActiveRecord::Base
  self.table_name  = 'bs.trashcustomer'
  self.primary_key = :trashcustkey
  belongs_to :customer, class_name: 'Bs::Customer', foreign_key: :custkey
  belongs_to :note,     class_name: 'Bs::Note',     foreign_key: :note_id
end
