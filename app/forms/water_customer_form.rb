# -*- encoding : utf-8 -*-
module WaterCustomerForm
  include Dima::Html

  CURR_BALANCE = NumberField.new(name: 'normal_water_balance', label: 'დავალიანება', after: 'GEL', required: true)
  PRE_PAYMENT = NumberField.new(name: 'pre_water_payment', label: 'წინასწარი გადახდა', after: 'GEL')

  def self.customer_form(cust)
    form = Form.new(title: 'წყალმომარაგების აბონენტი')
    form.col1 << CURR_BALANCE << PRE_PAYMENT
    form << cust
    form
  end

end
