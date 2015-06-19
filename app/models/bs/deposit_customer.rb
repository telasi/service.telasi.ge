class Bs::DepositCustomer < ActiveRecord::Base
  self.table_name  = 'bs.zdepozit_cust'
  self.primary_key = :custkey
end
