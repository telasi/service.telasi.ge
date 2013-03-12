# -*- encoding : utf-8 -*-
class Bs::TrashItem < ActiveRecord::Base
  self.table_name  = 'bs.trashitem'
  self.primary_key = :trashitemkey
  belongs_to :customer,  class_name: 'Bs::Customer', foreign_key: :custkey
  belongs_to :operation, class_name: 'Bs::Trashoperation', foreign_key: :operationid
  belongs_to :signee,    class_name: 'Bs::Person', foreign_key: :signid
  belongs_to :assistant, class_name: 'Bs::Person', foreign_key: :assistantid

  # ოპერაციის "ნორმალიზუბული" მნიშვნელობა.
  def normal_amount
    if self.operation.opergroupid == 2
      - self.amount
    else
      self.amount
    end
  end

  def normal_balance
    self.balance - self.normal_amount
  end

  def curr_balance
    self.balance - (self.old_balance || 0)
  end

end
