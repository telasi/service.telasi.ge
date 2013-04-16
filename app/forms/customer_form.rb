# -*- encoding : utf-8 -*-
module CustomerForm
  include Dima::Html

  # actions
  ACT_HISTORY = Action.new(label: 'ისტორია', tooltip: 'დარიცხვის ისტორია', icon: '/assets/fff/lightbulb.png', url: lambda{|v| Rails.application.routes.url_helpers.call_customer_items_path(custkey: v.custkey)})
  ACT_CUT_HISTORY = Action.new(label: 'ჩაჭრები', tooltip: 'ჩაჭრების ისტორია', icon: '/assets/fff/cut.png', url: lambda{|v| Rails.application.routes.url_helpers.call_customer_cuts_path(custkey: v.custkey)})
  ACT_TASKS = Action.new(label: 'დავალებები', tooltip: 'დავალებების ნახვა', icon: '/assets/fff/clock.png', url: lambda{|v| Rails.application.routes.url_helpers.call_customer_tasks_path(custkey: v.custkey)})
  ACT_TARIFFS = Action.new(label: 'ტარიფები', tooltip: 'ტარიფების ისტორია', icon: '/assets/fff/money.png', url: lambda{|v| Rails.application.routes.url_helpers.call_tariff_history_path(custkey: v.custkey)})
  ACT_BILLS = Action.new(label: 'ქვითრები', tooltip: 'ქვითრების ისტორია', icon: '/assets/fff/page_lightning.png', url: lambda{|v| Rails.application.routes.url_helpers.call_customer_bills_path(custkey: v.custkey) })

  def self.customer_table(custs)
    tbl = Table.new(title: 'აბონენტები', icon: '/assets/fff/group.png')
    tbl.cols << TextField.new(name: 'accnumb', label: 'აბ.ნომერი', required: true, url: lambda{|v| Rails.application.routes.url_helpers.call_customer_info_path(custkey: v.custkey)})
    tbl.cols << TextField.new(name: 'custname', label: 'დასახელება', required: true)
    tbl.cols << TextField.new(name: 'address.region', label: 'ბიზნეს-ცენტრი', required: true)
    tbl.cols << TextField.new(name: 'address', label: 'მისამართი', required: true)
    tbl.cols << NumberField.new(name: 'balance', label: 'დავალიანება', after: 'GEL', required: true)
    tbl.cols << BooleanField.new(name: 'cut', label: 'ჩაჭრილი?')
    tbl.vals = custs
    tbl
  end

  def self.customer_form(cust, opts = {})
    # col1
    pre = ComplexField.new(fields: [NumberField.new(name: 'pre_payment', after: 'GEL'), DateField.new(name: 'pre_payment_date', formatter: '%d-%b%Y %H:%M:%S')], label: 'დაუდ.გადახდა')
    form = Form.new(title: opts[:title] || 'აბონენტი', icon: '/assets/fff/user.png')
    form.col1 << TextField.new(name: 'accnumb', label: 'აბ.ნომერი', required: true, url: lambda{|v| Rails.application.routes.url_helpers.call_customer_info_path(custkey: v.custkey)})
    form.col1 << TextField.new(name: 'custname', label: 'დასახელება', required: true)
    form.col1 << NumberField.new(name: 'balance', label: 'დავალიანება', after: 'GEL', required: true)
    form.col1 << pre
    form.col1 << NumberField.new(name: 'old_balance', label: 'ძველი ვალი', after: 'GEL', required: true)
    form.col1 << TextField.new(name: 'address', label: 'მისამართი', required: true)
    form.col1 << TextField.new(name: 'send_address', label: 'ქვითრის მისამართი', required: true)
    # region data
    region = TextField.new(name: 'address.region')
    region_tel = TextField.new(name: 'address.region.ext_region.phone')
    form.col1 << ComplexField.new(fields: [region, region_tel], label: 'ბიზნეს-ცენტრი', required: true)
    form.col1 << TextField.new(name: 'address.region.ext_region.phone_exp', label: 'ექსპლუატაცია')
    # commercial
    form.col1 << TextField.new(name: 'taxid', label: 'გადამხ.კოდი', required: false)
    form.col1 << TextField.new(name: 'commercial', label: 'კომერც. დასახელება', required: false)
    form.col1 << TextField.new(name: 'tel', label: 'ტელეფონი')
    form.col1 << TextField.new(name: 'email', label: 'ელ.ფოსტა')
    # col2
    form.col2 << TextField.new(name: 'status_name', label: 'სტატუსი')
    form.col2 << TextField.new(name: 'category', label: 'კატეგორია', required: true)
    form.col2 << TextField.new(name: 'activity', label: 'საქმიანოვის სფერო')
    form.col2 << BooleanField.new(name: 'cut', label: 'ჩაჭრილი?')
    form.col2 << BooleanField.new(name: 'except', label: 'გამონაკლისი?')
    form.col2 << BooleanField.new(name: 'illegalline', label: 'უკანონო ხაზი?')
    form.col2 << DateField.new(name: 'createdate', label: 'შეიქმნა')
    form.col2 << DateField.new(name: 'closedate', label: 'დაიხურა')
    form.col2 << TextField.new(name: 'note', label: 'შენიშვნები')
    form.actions << ACT_HISTORY << ACT_CUT_HISTORY << ACT_TARIFFS #<< ACT_BILLS
    form.actions << ACT_TASKS
    form << cust
    form
  end

  def self.search(params)
    form = Form.new(title: 'აბონენტის ძებნა', icon: '/assets/fff/magnifier.png', submit: 'ძებნა', method: 'get')
    form.col1 << TextField.new(name: 'accnumb', label: 'აბ.ნომერი')
    form.col1 << TextField.new(name: 'custname', label: 'დასახელება')
    form.col1 << TextField.new(name: 'regionname', label: 'ბიზნ.ცენტრი')
    form.col2 << TextField.new(name: 'streetname', label: 'ქუჩა')
    form.col2 << TextField.new(name: 'building', label: 'სახლის №')
    form.col2 << TextField.new(name: 'flate', label: 'ბინის №')
    form << params.symbolize_keys if params
    form.edit = true
    form
  end

end
