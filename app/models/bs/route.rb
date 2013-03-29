# -*- encoding : utf-8 -*-
class Bs::Route < ActiveRecord::Base
  self.table_name  = 'bs.route'
  self.primary_key = :routekey
  belongs_to :account, class_name: 'Bs::Account', foreign_key: :acckey
  belongs_to :block, class_name: 'Bs::Block', foreign_key: :blockkey
end
