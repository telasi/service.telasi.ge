# -*- encoding : utf-8 -*-
class Bs::RouteStoreHeader < ActiveRecord::Base
  self.table_name  = 'bs.route_store_header'
  self.primary_key = :route_header_id
  has_many :all_items, class_name: 'Bs::RouteStoreItem', foreign_key: :route_header_id, order: :read_seq
  has_many :items, class_name: 'Bs::RouteStoreItem', foreign_key: :route_header_id, order: :read_seq, conditions: {status: 1}
end
