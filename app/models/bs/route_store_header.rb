# -*- encoding : utf-8 -*-
class Bs::RouteStoreHeader < ActiveRecord::Base
  STATUS_DEFAULT  = 0
  STATUS_SENT     = 1
  STATUS_RECEIVED = 2

  self.table_name  = 'bs.route_store_header'
  self.primary_key = :route_header_id
  has_many :all_items, class_name: 'Bs::RouteStoreItem', foreign_key: :route_header_id, order: :read_seq
  has_many :items, class_name: 'Bs::RouteStoreItem', foreign_key: :route_header_id, order: :read_seq, conditions: {error_code: nil}
  belongs_to :inspector, class_name: 'Bs::Person', foreign_key: :inspectorid

  def sent?
    self.status == STATUS_SENT
  end

  def complete?
    self.status == STATUS_RECEIVED
  end

end
