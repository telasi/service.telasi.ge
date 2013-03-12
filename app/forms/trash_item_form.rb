# -*- encoding : utf-8 -*-
module TrashItemForm
  include Dima::Html

  OPERDATE = DateField.new(name: 'operdate', label: 'თარიღი', required: true)
  ACCNUMB = TextField.new(name: 'customer.accnumb', label: 'აბ.ნომერი')
  OPERATION = TextField.new(name: 'operation.description', label: 'ოპერაცია', required: true)
  AMOUNT = NumberField.new(name: 'normal_amount', label: 'თანხა', after: 'GEL')
  CURR_BALANCE = NumberField.new(name: 'curr_balance', label: 'მიმდ.ვალი', after: 'GEL')
  BALANCE = NumberField.new(name: 'balance', label: 'სრული ვალი', after: 'GEL')

  def self.item_table(items)
    tbl = Table.new(title: 'აბონენტის დასუფთავების ისტორია', icon: '/assets/fff/bin.png')
    tbl.cols << OPERDATE << ACCNUMB << OPERATION << AMOUNT
    tbl.cols << CURR_BALANCE << BALANCE
    tbl.vals = items
    tbl
  end

end
