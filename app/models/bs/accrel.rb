# -*- encoding : utf-8 -*-
class Bs::Accrel < ActiveRecord::Base
  self.table_name  = 'bs.accrel'
  self.primary_key = 'acckey'
  belongs_to :account, class_name: 'Bs::Account', foreign_key: :acckey
end
