# -*- encoding : utf-8 -*-
class Bs::Account < ActiveRecord::Base
  self.table_name  = 'bs.account'
  self.primary_key = :acckey
  belongs_to :customer, class_name: 'Bs::Customer', foreign_key: :custkey
  belongs_to :address,  class_name: 'Bs::Address',  foreign_key: :premisekey
end
