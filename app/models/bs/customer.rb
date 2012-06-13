# -*- encoding : utf-8 -*-
class Bs::Customer < ActiveRecord::Base
  self.table_name  = "CUSTOMER"
  self.primary_key = :custkey
end
