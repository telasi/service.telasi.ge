# -*- encoding : utf-8 -*-
module ItemForm
  include Dima::Html

  ACCNUMB = TextField.new(name: 'customer.accnumb', label: 'აბ.ნომერი', required: true)
  ACCID = TextField.new(name: 'account.accid', label: 'ანგარიში', required: true)
  OPERATION = TextField.new(name: 'operation', label: 'ოპერაცია', required: true, url: lambda{|v| Rails.application.routes.url_helpers.call_customer_item_path(itemkey: v.itemkey)})
  ITEMDATE = DateField.new(name: 'itemdate', label: 'თარიღი', required: true)
  READING = NumberField.new(name: 'reading', label: 'წაკითხვა', after: 'kWh', required: true, precision: 3)
  CHARGE =NumberField.new(name: 'kwt', label: 'დარიცხვა', after: 'kWh', required: true)
  AMOUNT = NumberField.new(name: 'normal_amount', label: 'თანხა', after: 'GEL', required: true)
  BALANCE = NumberField.new(name: 'normal_balance', label: 'დავალიანება', after: 'GEL', required: true)
  PREV_BALANCE = NumberField.new(name: 'balance', label: 'წინა დავალიანება', after: 'GEL', required: true)

  DOCNUM = TextField.new(name: 'itemnumber', label: 'დოკუმენტის №')
  CYCLE = BooleanField.new(name: 'cycle?', label: 'ციკლი?', required: true)
  ENTERDATE = DateField.new(name: 'enterdate', label: 'შეყვანის თარიღი', formatter: '%d-%b-%Y %H:%M:%S', required: true)
  PERSON = TextField.new(name: 'person', label: 'ოპერატორი', required: true)
  NOTE = TextField.new(name: 'note', label: 'შენიშვნები')

  def self.item_form(item)
    form = Form.new(title: 'ოპერაციის დეტალები', icon: '/assets/fff/lightbulb.png')
    form.col1 << ACCNUMB << ACCID << OPERATION << ITEMDATE
    form.col1 << READING << CHARGE << AMOUNT << BALANCE << PREV_BALANCE
    form.col2 << DOCNUM << CYCLE << ENTERDATE << PERSON << NOTE
    #form.actions << ACT_HISTORY << ACT_CUT_HISTORY
    form << item
    form
  end

  def self.item_table(items)
    tbl = Table.new(title: 'აბონენტის დარიცხვის ისტორია', icon: '/assets/fff/lightbulb.png')
    tbl.cols << ITEMDATE << ACCID << OPERATION
    tbl.cols << CYCLE << READING << CHARGE << AMOUNT << BALANCE
    tbl.vals = items
    tbl
  end

end
