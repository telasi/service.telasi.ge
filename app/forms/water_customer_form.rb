# -*- encoding : utf-8 -*-
module WaterCustomerForm
  include Dima::Html

  def self.customer_form(cust)
    f1 = NumberField.new(name: 'pre_water_payment', after: 'GEL')
    f2 = DateField.new(name: 'pre_water_payment_date', formatter: '%d-%b-%Y %H:%M:%S', not_local: true)
    pre = ComplexField.new(fields: [f1, f2], label: 'დაუდ.გადახდა')
    form = Form.new(title: 'წყალმომარაგების აბონენტი')
    form.col1 << NumberField.new(name: 'water_balance', label: 'სრული ვალი', after: 'GEL', required: true)
    form.col1 << NumberField.new(name: 'current_water_balance', label: 'მიმდ.ვალი', after: 'GEL', required: true)
    form.col1 << pre
    form << cust
    form
  end
end
