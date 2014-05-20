# -*- encoding : utf-8 -*-
class Bs::RouteStoreItem < ActiveRecord::Base
  self.table_name  = 'bs.route_store_detail'
  self.primary_key = :rtstorekey
  belongs_to :route, class_name: 'Bs::RouteStoreHeader', foreign_key: :route_header_id
  belongs_to :account, class_name: 'Bs::Account', foreign_key: :acckey
  set_integer_columns :cur_status, :cur_mtstat, :cur_sealstat, :cur_cut

  def estimate_charge
    if self.new_reading and self.new_reading.abs > 0.00099
      (self.new_reading - self.prv_reading) * self.cur_mtkoef
    else
      0
    end
  end
end
