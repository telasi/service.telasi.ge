# -*- encoding : utf-8 -*-
module AccountForm
  include Dima::Html

  # fields

  ACCID = TextField.new(name: 'accid', label: 'ანგარიში', required: true)
  ADDRESS = TextField.new(name: 'address', label: 'მისამართი', required: true)
  REGION = TextField.new(name: 'address.region', label: 'ბიზნეს-ცენტრი', required: true)
  BLOCK = TextField.new(name: 'route_account.route.block.blockname', label: 'ბლოკი', required: true)
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
  TYPE = TextField.new(name: 'account_type')
  TYPE_ICON = IconField.new(name: 'account_type_icon')

  def self.account_form(acc, opts = {})
    form = Form.new(title:  opts[:title] || "ანგარიში №#{acc.accid.to_ka}", icon: '/assets/fff/lightbulb.png')
    form.col1 << ACCID.clone << ADDRESS.clone << REGION.clone << BLOCK.clone << INST_CAP.clone
    form.col1 << METER_NAME.clone << METER_NUMB.clone << METER_COEF.clone << METER_DIGS.clone
    form.col1 << ComplexField.new(label: 'სახეობა', fields: [TYPE_ICON.clone, TYPE.clone])
    trace = ArrayField.new(label: 'კვება', name: 'parents', field: ComplexField.new(fields: [TYPE_ICON.clone, ACCID.clone, TextField.new(name: 'customer.custname', klass: 'muted')]))
    form.col1 << trace
    form.col2 << MAINACC.clone << STATUS.clone
    form.col2 << CREATE_DATE.clone << CLOSE_DATE.clone << NOTE.clone
    form << acc
    form
  end

  def self.account_tariff_table(acc)
    tbl = Table.new(title: "ანგარიში №#{acc.accid.to_ka}", icon: '/assets/fff/lightbulb.png')
    tbl.cols << TextField.new(name: 'account.accid', label: 'ანგარიში')
    tbl.cols << DateField.new(name: 'startdate', label: 'დაწყება')
    tbl.cols << DateField.new(name: 'enddate', label: 'დასრულება')
    tbl.cols << BooleanField.new(name: 'status', label: 'გაუქმ?')
    tbl.cols << TextField.new(name: 'tariff.compname', label: 'ტარიფი')
    tbl.cols << NumberField.new(name: 'tariff.amount', label: 'ტარიფი', after: 'GEL', precision: 5)
    tbl.vals = acc.tariffs
    tbl
  end

  def self.tariff_steps(tar)
    tbl = Table.new(title: tar.compname.to_ka, icon: '/assets/fff/cog.png')
    tbl.cols << TextField.new(name: 'tariff.compname', label: 'ტარიფი')
    tbl.cols << TextField.new(name: 'ts_seq', label: 'ბიჯი', before: '#')
    tbl.cols << NumberField.new(name: 'ts_upper_bnd', label: 'ზედა ზღვარი', after: 'kWh')
    tbl.cols << NumberField.new(name: 'ts_val', label: 'ფასი', after: 'GEL', precision: 5)
    tbl.collapsed = true
    tbl.vals = tar.steps
    tbl
  end

end
