# -*- encoding : utf-8 -*-
module AccountForm
  include Dima::Html

  # fields

  ACCID = TextField.new(name: 'accid', label: 'ანგარიში', required: true)
  ADDRESS = TextField.new(name: 'address', label: 'მისამართი', required: true)
  REGION = TextField.new(name: 'address.region', label: 'ბიზნეს-ცენტრი', required: true)
  INST_CAP = NumberField.new(name: 'inst_cp', label: 'დადგმ.სიმძლავრე', precision: 0, after: 'kWh')
  METER_NAME = TextField.new(name: 'meter_type.mtname', label: 'მრიცხველი')
  METER_NUMB = TextField.new(name: 'mtnumb', label: 'მრიცხველის №')
  METER_COEF = NumberField.new(name: 'mtkoef', label: 'კოეფიციენტი', precision: 0, before: '&times;')
  METER_DIGS = NumberField.new(name: 'meter_type.digit', label: 'თანრიგი', precision: 0)

  MAINACC = BooleanField.new(name: 'mainaccount', label: 'ძირითადი ანგარიში?', required: true)
  STATUS = TextField.new(name: 'status', label: 'სტატუსი', required: true)
  CREATE_DATE = DateField.new(name: 'createdate', label: 'შეიქმნა', required: true)
  CLOSE_DATE = DateField.new(name: 'closedate', label: 'დაიხურა')
  NOTE = TextField.new(name: 'note', label: 'შენიშვნები')

  def self.account_form(acc, opts = {})
    form = Form.new(title:  opts[:title] || 'ანგარიში და მრიცხველი', icon: '/assets/fff/cog.png')
    form.col1 << ACCID << ADDRESS << REGION << INST_CAP
    form.col1 << METER_NAME << METER_NUMB << METER_COEF << METER_DIGS
    form.col2 << MAINACC << STATUS << CREATE_DATE << CLOSE_DATE << NOTE
    form << acc
    form
  end

  def self.account_tariff_table(acc)
    tbl = Table.new(title: "ანგარიში №#{acc.accid.to_ka}", icon: '/assets/fff/cog.png')
    tbl.cols << TextField.new(name: 'account.accid', label: 'ანგარიში')
    tbl.cols << DateField.new(name: 'startdate', label: 'დაწყება')
    tbl.cols << DateField.new(name: 'enddate', label: 'დასრულება')
    tbl.cols << BooleanField.new(name: 'status', label: 'გაუქმ?')
    tbl.cols << TextField.new(name: 'tariff.compname', label: 'ტარიფი')
    tbl.cols << NumberField.new(name: 'tariff.amount', label: 'ტარიფი', after: 'GEL')
    tbl.vals = acc.tariffs
    tbl
  end

end
