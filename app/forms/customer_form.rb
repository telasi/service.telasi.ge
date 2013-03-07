# -*- encoding : utf-8 -*-
module CustomerForm
  include Dima::Html

  # fields

  ACCNUMB = TextField.new(name: 'accnumb', label: 'აბ.ნომერი', required: true)
  CUSTNAME = TextField.new(name: 'custname', label: 'დასახელება', required: true)
  BALANCE = NumberField.new(name: 'balance', label: 'დავალიანება', after: 'GEL', required: true)
  OLD_BALANCE = NumberField.new(name: 'old_balance', label: 'ძველი ვალი', after: 'GEL', required: true)
  ADDRESS = TextField.new(name: 'address', label: 'მისამართი', required: true)
  SEND_ADDRESS = TextField.new(name: 'send_address', label: 'ქვითრის მისამართი', required: true)
  REGION = TextField.new(name: 'address.region', label: 'ბიზნეს-ცენტრი', required: true)
  TAXID = TextField.new(name: 'taxid', label: 'გადამხ.კოდი', required: false)
  COMERCIAL = TextField.new(name: 'commercial', label: 'კომერც. დასახელება', required: false)
  PHONE = TextField.new(name: 'tel', label: 'ტელეფონი')
  EMAIL = TextField.new(name: 'email', label: 'ელ.ფოსტა')
  STATUS = TextField.new(name: 'status_name', label: 'სტატუსი')
  CATEG = TextField.new(name: 'category', label: 'კატეგორია', required: true)
  ACTIVITY = TextField.new(name: 'activity', label: 'საქმიანოვის სფერო')
  CUT = BooleanField.new(name: 'cut', label: 'ჩაჭრილი?')
  EXCEPT = BooleanField.new(name: 'except', label: 'გამონაკლისი?')
  ILLEGAL_LINE = BooleanField.new(name: 'illegalline', label: 'უკანონო ხაზი?')
  CREATE_DATE = DateField.new(name: 'createdate', label: 'შეიქმნა')
  CLOSE_DATE = DateField.new(name: 'closedate', label: 'დაიხურა')
  NOTE = TextField.new(name: 'note', label: 'შენიშვნები')

  # actions
  ACT_HISTORY = Action.new(label: 'ისტორია', tooltip: 'დარიცხვის ისტორია', icon: '/assets/fff/lightbulb.png', url: lambda{|v| Rails.application.routes.url_helpers.call_customer_items_path(custkey: v.custkey)})
  ACT_CUT_HISTORY = Action.new(label: 'ჩაჭრები', tooltip: 'ჩაჭრების ისტორია', icon: '/assets/fff/cut.png', url: lambda{|v| Rails.application.routes.url_helpers.call_customer_cuts_path(custkey: v.custkey)})

  def self.customer_form(cust)
    form = Form.new(title: 'ელ.ენერგიის აბონენტი', icon: '/assets/fff/user.png')
    form.col1 << ACCNUMB << CUSTNAME << BALANCE << OLD_BALANCE << ADDRESS
    form.col1 << SEND_ADDRESS << REGION << TAXID << COMERCIAL << PHONE << EMAIL
    form.col2 << STATUS << CATEG << ACTIVITY << CUT << EXCEPT << ILLEGAL_LINE
    form.col2 << CREATE_DATE << CLOSE_DATE << NOTE
    form.actions << ACT_HISTORY << ACT_CUT_HISTORY
    form << cust
    form
  end

end
