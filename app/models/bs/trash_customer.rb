# -*- encoding : utf-8 -*-
class Bs::TrashCustomer < ActiveRecord::Base
  ACTIVE = 0
  INACTIVE = 1
  CLOSED = 2
  NOT_EXISTING = 3

  self.table_name  = 'bs.trashcustomer'
  self.primary_key = :trashcustkey
  belongs_to :customer, class_name: 'Bs::Customer', foreign_key: :custkey
  belongs_to :note,     class_name: 'Bs::Note',     foreign_key: :note_id

  def status_name
    case self.status
    when ACTIVE then 'აქტიური'
    when INACTIVE then 'გაუქმებული'
    when CLOSED then 'დახურული'
    when NOT_EXISTING then 'არ არსებული'
    else '?'
    end
  end

end
