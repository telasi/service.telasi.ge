# -*- encoding : utf-8 -*-
class Bs::RouteStoreHeader < ActiveRecord::Base
  # საწყისი სტატუსი
  STATUS_DEFAULT  = 0
  # ინსპექტორმა ჩამოტვირთა.
  STATUS_SENT     = 1
  # ინსპექტორმა დაასრულა მონაცემების შეყვანა.
  STATUS_RECEIVED = 2
  # მარშრუტი გაიგზავნა ბილინგში.
  STATUS_SYNCED   = 3

  self.table_name  = 'bs.route_store_header'
  self.primary_key = :route_header_id
  has_many :all_items, class_name: 'Bs::RouteStoreItem', foreign_key: :route_header_id, order: :read_seq
  has_many :items, class_name: 'Bs::RouteStoreItem', foreign_key: :route_header_id, order: :read_seq, conditions: {error_code: nil}
  belongs_to :inspector, class_name: 'Bs::Person', foreign_key: :inspectorid
  belongs_to :route, class_name: 'Bs::Route', foreign_key: :routekey

  def sent?
    self.status == STATUS_SENT
  end

  def complete?
    self.status == STATUS_RECEIVED
  end

  def synced?
    self.status == STATUS_SYNCED
  end

  def can_sync?
    self.complete? or self.synced?
  end

end
