# -*- encoding : utf-8 -*-
class Bs::AccountRelation < ActiveRecord::Base
  self.table_name  = 'bs.accrel'
  self.primary_key = :acckey
  belongs_to :account, class_name: 'Bs::Account', foreign_key: :acckey
  belongs_to :parent, class_name: 'Bs::Account', foreign_key: :base_acckey
end
