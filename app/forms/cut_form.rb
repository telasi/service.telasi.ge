# -*- encoding : utf-8 -*-
module CutForm
  include Dima::Html

  ACCID = TextField.new(name: 'account.accid', label: 'ანგარიში', required: true)
  OPER_DATE = DateField.new(name: 'oper_date', label: 'თარიღი', required: true)
  MARK_DATE = DateField.new(name: 'mark_date', label: 'გენერაციის თარიღი', required: true)
  OPERATION = TextField.new(name: 'operation', label: 'ოპერაცია', required: true, url: lambda{|v| Rails.application.routes.url_helpers.call_customer_cut_path(cutkey: v.cr_key)})
  RESULT = TextField.new(name: 'result', label: 'შესრულება')
  NOTE = TextField.new(name: 'note', label: 'შენიშვნა')

  BALANCE = NumberField.new(name: 'balance', label: 'ელქტრ.ვალი', after: 'GEL')
  BALANCE_TR = NumberField.new(name: 'balance_tr', label: 'დასუფთ.ვალი', after: 'GEL')
  BALANCE_WR = NumberField.new(name: 'balance_w', label: 'წყლის ვალი', after: 'GEL')
  CAUSE_EL = BooleanField.new(name: 'stat_el', label: 'ელქტრ.გამო')
  CAUSE_TR = BooleanField.new(name: 'stat_tr', label: 'დასუფთ.გამო')
  CAUSE_WR = BooleanField.new(name: 'stat_w', label: 'წყლის გამო')

  def self.cut_form(cut)
    form = Form.new(title: 'ჩაჭრა-აღდგენის ოპერაცია', icon: '/assets/fff/cut.png')
    form.col1 << ACCID << OPER_DATE << MARK_DATE << OPERATION << RESULT << NOTE
    form.col2 << BALANCE << BALANCE_TR << BALANCE_WR << CAUSE_EL << CAUSE_TR << CAUSE_WR
    form << cut
    form
  end

  def self.cut_table(cuts)
    tbl = Table.new(title: 'აბონენტის ჩაჭრა-აღდგენის ისტორია', icon: '/assets/fff/cut.png')
    tbl.cols << OPER_DATE << ACCID << OPERATION << RESULT
    tbl.cols << CAUSE_EL << CAUSE_TR << CAUSE_WR
    tbl.vals = cuts
    tbl
  end

end
