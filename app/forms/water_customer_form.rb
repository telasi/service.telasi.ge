# -*- encoding : utf-8 -*-
module WaterCustomerForm
  include Dima::Html

  CURR_BALANCE = NumberField.new(name: 'water_balance', label: 'დავალიანება', after: 'GEL', required: true)
  PRE_PAYMENT_AMNT = NumberField.new(name: 'pre_water_payment', after: 'GEL')
  PRE_PAYMENT_DATE = DateField.new(name: 'pre_water_payment_date', formatter: '%d-%b-%Y %H:%M:%S')

  def self.customer_form(cust)
    pre = ComplexField.new(fields: [PRE_PAYMENT_AMNT, PRE_PAYMENT_DATE], label: 'წინასწარი გადახდა')
    form = Form.new(title: 'წყალმომარაგების აბონენტი')
    form.col1 << CURR_BALANCE << pre
    form << cust
    form
  end

end
