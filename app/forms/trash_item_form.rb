# -*- encoding : utf-8 -*-
module TrashItemForm
  include Dima::Html

  OPERDATE = DateField.new(name: 'operdate', label: 'თარიღი', required: true)
  ACCNUMB = TextField.new(name: 'customer.accnumb', label: 'აბ.ნომერი', required: true, url: lambda{|v| Rails.application.routes.url_helpers.call_customer_info_path(custkey: v.customer.custkey)})
  OPERATION = TextField.new(name: 'operation.description', label: 'ოპერაცია', required: true, url: lambda{|v| Rails.application.routes.url_helpers.call_customer_trash_item_path(trashitemid: v.trashitemid)})
  AMOUNT = NumberField.new(name: 'normal_amount', label: 'თანხა', after: 'GEL', required: true)
  BALANCE = NumberField.new(name: 'balance', label: 'სრული ვალი', after: 'GEL', required: true)
  CURR_BALANCE = NumberField.new(name: 'curr_balance', label: 'მიმდ.ვალი', after: 'GEL', required: true)
  OLD_BALANCE = NumberField.new(name: 'old_balance', label: 'ძველი ვალი', after: 'GEL', required: true)
  SIGNEE = TextField.new(name: 'signee', label: 'ოპერატორი')
  ASSISTANT = TextField.new(name: 'assistant', label: 'ასისტენტი')
  DOCNUMB = TextField.new(name: 'trashitemnumber', label: 'დოკუმენტის №')
  ENTERDATE = DateField.new(name: 'enterdate', label: 'შეყვანის თარიღი', formatter: '%d-%b-%Y %H:%M:%S')
  KWH = NumberField.new(name: 'kwt', label: 'ელ.ენერგ.დარიცხვა', after: 'kWh')

  def self.item_table(items)
    tbl = Table.new(title: 'აბონენტის დასუფთავების ისტორია', icon: '/assets/fff/bin.png')
    tbl.cols << OPERDATE << ACCNUMB << OPERATION << AMOUNT
    tbl.cols << BALANCE << CURR_BALANCE << OLD_BALANCE
    tbl.vals = items
    tbl
  end

  def self.item_form(item)
    form = Form.new(title: 'დასუფთავების ოპერაციის დეტალები', icon: '/assets/fff/bin.png')
    form.col1 << OPERDATE << ACCNUMB << OPERATION << AMOUNT << CURR_BALANCE << BALANCE
    form.col2 << KWH << DOCNUMB << ENTERDATE << SIGNEE << ASSISTANT
    form << item
    form
  end

end
