# -*- encoding : utf-8 -*-
module WaterCustomer
  include Dima::Html

  CURR_BALANCE = NumberField.new(name: 'normal_water_balance', label: 'დავალიანება', after: 'GEL', required: true)

  def self.customer_form(cust)
    form = Form.new(title: 'წყალმომარაგების აბონენტი')
    form.col1 << CURR_BALANCE
    form << cust
    form
  end

end
