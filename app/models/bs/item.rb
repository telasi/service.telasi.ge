# -*- encoding : utf-8 -*-
class Bs::Item < ActiveRecord::Base
  self.table_name  = 'bs.item'
  self.primary_key = :itemkey
  belongs_to :customer, class_name: 'Bs::Customer', foreign_key: :custkey
  belongs_to :account,  class_name: 'Bs::Account',  foreign_key: :acckey
end
