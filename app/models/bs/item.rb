# -*- encoding : utf-8 -*-
class Bs::Item < ActiveRecord::Base
  self.table_name  = 'bs.item'
  self.primary_key = :itemkey
  belongs_to :customer,  class_name: 'Bs::Customer', foreign_key: :custkey
  belongs_to :account,   class_name: 'Bs::Account',  foreign_key: :acckey
  belongs_to :operation, class_name: 'Bs::Billoperation', foreign_key: :billoperkey
  belongs_to :person,    class_name: 'Bs::Person', foreign_key: :perskey
  belongs_to :signee,    class_name: 'Bs::Person', foreign_key: :signkey
  has_one    :note,      class_name: 'Bs::Note',   foreign_key: :notekey

  # ოპერაციის "ნორმალიზუბული" მნიშვნელობა.
  def normal_amount
    if self.operation.opertpkey == 3
      - self.amount
    else
      self.amount
    end
  end

  # ოპერაციის ნორმალიზებული ბალანსი.
  def normal_balance
    self.balance + self.normal_amount
  end

  def cycle?
    !self.schedkey.nil?
  end

end
