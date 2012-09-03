# -*- encoding : utf-8 -*-
class Bs::RouteStoreItem < ActiveRecord::Base
  self.table_name  = 'bs.route_store_detail'
  self.primary_key = :route_header_id
  belongs_to :route, class_name: 'Bs::RouteStoreHeader', foreign_key: :route_header_id
  belongs_to :account, class_name: 'Bs::Account', foreign_key: :acckey
  set_integer_columns :cur_status, :cur_mtstat, :cur_sealstat, :cur_cut
end
