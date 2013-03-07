# -*- encoding : utf-8 -*-
module TrashCustomer
  include Dima::Html

  ACCNUMB = TextField.new(name: 'customer.accnumb', label: 'აბ.ნომერი', required: true)
  CUSTNAME = TextField.new(name: 'customer.custname', label: 'დასახელება', required: true)

  CURR_BALANCE = NumberField.new(name: 'curr_balance', label: 'მიმდინარე ვალი', after: 'GEL', required: true)
  BALANCE = NumberField.new(name: 'balance', label: 'სრული დავალიანება', after: 'GEL', required: true)
  OLD_BALANCE = NumberField.new(name: 'old_balance', label: 'ძველი ვალი', after: 'GEL', required: true)

  STATUS = TextField.new(name: 'status_name', label: 'სტატუსი')
  EXCEPT = BooleanField.new(name: 'except', label: 'გამონაკლისი?')
  CREATE_DATE = DateField.new(name: 'firstregistrationdate', label: 'შეიქმნა')
  NOTE = TextField.new(name: 'note', label: 'შენიშვნები')

  # actions
  ACT_HISTORY = Action.new(label: 'ისტორია', tooltip: 'დარიცხვის ისტორია', icon: '/assets/fff/lightbulb.png', url: lambda{|v| Rails.application.routes.url_helpers.call_customer_items_path(custkey: v.custkey)})
  ACT_CUT_HISTORY = Action.new(label: 'ჩაჭრები', tooltip: 'ჩაჭრების ისტორია', icon: '/assets/fff/cut.png', url: lambda{|v| Rails.application.routes.url_helpers.call_customer_cuts_path(custkey: v.custkey)})

  def self.customer_form(cust)
    form = Form.new(title: 'დასუფთავების აბონენტი', icon: '/assets/fff/bin.png')
    form.col1 << ACCNUMB << CUSTNAME << CURR_BALANCE << BALANCE << OLD_BALANCE
    form.col2 << STATUS << EXCEPT << CREATE_DATE << NOTE
    #form.actions << ACT_HISTORY << ACT_CUT_HISTORY
    form << cust
    form
  end

end
