# -*- encoding : utf-8 -*-
class Bs::RouteAccount < ActiveRecord::Base
  self.table_name  = 'bs.routeacc'
  self.primary_key = :routeacckey
  belongs_to :account, class_name: 'Bs::Account', foreign_key: :acckey
  belongs_to :route, class_name: 'Bs::Route', foreign_key: :routekey
end
