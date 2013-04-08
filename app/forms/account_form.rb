# -*- encoding : utf-8 -*-
module AccountForm
  include Dima::Html

  def self.account_form(acc, opts = {})
    form = Form.new(title:  opts[:title] || "ანგარიში №#{acc.accid.to_ka}", icon: '/assets/fff/lightbulb.png')
    # COL 1
    form.col1 << TextField.new(name: 'accid', label: 'ანგარიში', required: true)
    form.col1 << TextField.new(name: 'address', label: 'მისამართი', required: true)
    form.col1 << TextField.new(name: 'address.region', label: 'ბიზნეს-ცენტრი', required: true)
    form.col1 << TextField.new(name: 'route_account.route.block.blockname', label: 'ბლოკი', required: true)
    form.col1 << NumberField.new(name: 'inst_cp', label: 'დადგმ.სიმძლავრე', precision: 0, after: 'kWh')
    form.col1 << TextField.new(name: 'meter_type.mtname', label: 'მრიცხველი')
    form.col1 << TextField.new(name: 'mtnumb', label: 'მრიცხველის №')
    form.col1 << NumberField.new(name: 'mtkoef', label: 'კოეფიციენტი', precision: 0, before: '&times;')
    form.col1 << NumberField.new(name: 'meter_type.digit', label: 'თანრიგი', precision: 0)
    form.col1 << ComplexField.new(label: 'სახეობა', fields: [IconField.new(name: 'account_type_icon'), TextField.new(name: 'account_type')])
    trace = ArrayField.new(label: 'კვება', name: 'parents',
      field: ComplexField.new(fields: [
        IconField.new(name: 'account_type_icon'),
        TextField.new(name: 'accid', label: 'ანგარიში', required: true),
        TextField.new(name: 'customer.custname', klass: 'muted')]))
    form.col1 << trace
    # COL 2
    form.col2 << BooleanField.new(name: 'mainaccount', label: 'ძირითადი ანგარიში?', required: true)
    form.col2 << TextField.new(name: 'status', label: 'სტატუსი', required: true)
    form.col2 << DateField.new(name: 'createdate', label: 'შეიქმნა', required: true)
    form.col2 << DateField.new(name: 'closedate', label: 'დაიხურა')
    form.col2 << TextField.new(name: 'note', label: 'შენიშვნები')
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
