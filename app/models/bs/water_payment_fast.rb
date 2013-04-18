# -*- encoding : utf-8 -*-

# TODO: not yet used !!!

# ეს გადახდები არ შეიცავს ასახვა/არაასახულის თვისებას (როგორც Bs::WaterPayment).
# დადარება Bs::WaterPayment-თან უნდა მოხდეს ტრანზაქციის მიხედვით.
#

class Bs::WaterPaymentFast < ActiveRecord::Base
  self.table_name  = 'paymentsadmin.payments_gwp'
  self.primary_key = :opayment_id
  belongs_to :customer, class_name: 'Bs::Customer', foreign_key: :custkey
end
