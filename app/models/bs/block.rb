# -*- encoding : utf-8 -*-
class Bs::Block < ActiveRecord::Base
  self.table_name  = 'bs.block'
  self.primary_key = :blockkey
  belongs_to :region, class_name: 'Bs::Region', foreign_key: :regionkey
end
