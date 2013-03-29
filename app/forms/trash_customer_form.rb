# -*- encoding : utf-8 -*-
module TrashCustomerForm
  include Dima::Html

  ACCNUMB = TextField.new(name: 'customer.accnumb', label: 'აბ.ნომერი', required: true)
  CUSTNAME = TextField.new(name: 'customer.custname', label: 'დასახელება', required: true)

  CURR_BALANCE = NumberField.new(name: 'curr_balance', label: 'მიმდინარე ვალი', after: 'GEL', required: true)
  BALANCE = NumberField.new(name: 'balance', label: 'სრული დავალიანება', after: 'GEL', required: true)
  OLD_BALANCE = NumberField.new(name: 'old_balance', label: 'ძველი ვალი', after: 'GEL', required: true)
  PRE_PAYMENT_AMNT = NumberField.new(name: 'customer.pre_trash_payment')
  PRE_PAYMENT_DATE = DateField.new(name: 'customer.pre_trash_payment_date', formatter: '%d-%b-%Y %H:%M:%S')

  STATUS = TextField.new(name: 'status_name', label: 'სტატუსი')
  EXCEPT = BooleanField.new(name: 'except', label: 'გამონაკლისი?')
  CREATE_DATE = DateField.new(name: 'firstregistrationdate', label: 'შეიქმნა')
  NOTE = TextField.new(name: 'note', label: 'შენიშვნები')

  # actions
  ACT_HISTORY = Action.new(label: 'ისტორია', tooltip: 'დარიცხვის ისტორია', icon: '/assets/fff/bin.png', url: lambda{|v| Rails.application.routes.url_helpers.call_customer_trash_items_path(custkey: v.custkey)})

  def self.customer_form(cust)
    pre = ComplexField.new(fields: [PRE_PAYMENT_AMNT, PRE_PAYMENT_DATE], label: 'წინასწარი გადახდა')
    form = Form.new(title: 'დასუფთავების აბონენტი', icon: '/assets/fff/bin.png')
    form.col1 << ACCNUMB << CUSTNAME << CURR_BALANCE << BALANCE << OLD_BALANCE << pre
    form.col2 << STATUS << EXCEPT << CREATE_DATE << NOTE
    form.actions << ACT_HISTORY
    form << cust if cust
    form
  end

end
