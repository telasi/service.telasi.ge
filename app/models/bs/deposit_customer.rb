class Bs::DepositCustomer < ActiveRecord::Base
  self.table_name  = 'bs.zdepozit_cust'
  self.primary_key = :custkey
  self.set_integer_columns :status

  def active?; self.status == 0 end
end
