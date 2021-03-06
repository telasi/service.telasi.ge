# -*- encoding : utf-8 -*-
class Bs::Customer < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper
  ACTIVE = 0
  INACTIVE = 1
  CLOSED = 2

  self.table_name  = 'bs.customer'
  self.primary_key = :custkey
  belongs_to :address,      class_name: 'Bs::Address',       foreign_key: :premisekey
  belongs_to :send_address, class_name: 'Bs::Address',       foreign_key: :sendkey
  has_one  :trash_customer, class_name: 'Bs::TrashCustomer', foreign_key: :custkey
  has_one  :water_customer, class_name: 'Bs::WaterCustomer', foreign_key: :custkey
  has_many :water_items,    class_name: 'Bs::WaterItem',     foreign_key: :custkey, order: 'year, month'
  has_many :item_bills,     class_name: 'Bs::ItemBill',      foreign_key: :custkey, order: 'itemkey'
  has_many :accounts,       class_name: 'Bs::Account',       foreign_key: :custkey
  has_one  :note,           class_name: 'Bs::Note',          foreign_key: :notekey
  #has_one  :deposit_customer, -> { where status: 0 }, class_name: 'Bs::DepositCustomer', foreign_key: :custkey
  belongs_to :category,     class_name: 'Bs::Custcateg',     foreign_key: :custcatkey
  belongs_to :activity,     class_name: 'Bs::Custcateg',     foreign_key: :activity
  has_one  :water_exceptions, class_name: 'Bs::WaterExceptions', foreign_key: :accnumb , primary_key: :accnumb  
  has_many :payments, class_name: 'Bs::Payment', foreign_key: :custkey    

  def water_form_field 
    self.water_exceptions.water_form_fld
  end

  def deposit_customer
    Bs::DepositCustomer.where(custkey: self.custkey, status: 0).first
  end

  def pre_payment
    Bs::Payment.where('paydate > ? AND custkey = ? AND status = 1', Date.today - 7, self.custkey).inject(0) do |sum, payment|
      sum += payment.amount
    end
  end

  def pre_payment_date
    p = Bs::Payment.where('paydate > ? AND custkey = ? AND status = 1', Date.today - 7, self.custkey).order('paykey desc').first
    p.paydate if p
  end

  def pre_trash_payment
    Bs::TrashPayment.where('paydate > ? AND custkey = ? AND status = 1', Date.today - 7, self.custkey).inject(0) do |sum, payment|
      sum += payment.amount
    end
  end

  def pre_trash_payment_date
    p = Bs::TrashPayment.where('paydate > ? AND custkey = ? AND status = 1', Date.today - 7, self.custkey).order('paykey desc').first
    p.paydate if p
  end

  def pre_water_payment
    Bs::WaterPayment.where('paydate > ? AND custkey = ? AND status = 1', Date.today - 7, self.custkey).inject(0) do |sum, payment|
      sum += payment.amount
    end
  end

  def pre_water_payment_date
    p = Bs::WaterPayment.where('paydate > ? AND custkey = ? AND status = 1', Date.today - 7, self.custkey).order('paykey desc').first
    p.paydate if p
  end

  def normal_balance; self.balance - (self.pre_payment || 0) end
  def normal_trash_balance; self.trash_customer ? (self.trash_customer.curr_balance - (self.pre_trash_payment || 0)) : 0 end
  
  def water_balance; self.water_customer.new_balance end
  def current_water_balance; self.water_customer.curr_charge end

  # def normal_water_balance
  #   water_item = self.water_items.last
  #   self.water_balance - (self.pre_water_payment || 0)
  # end

  # def cut_candidate?
  #   self.normal_balance > 0.50 or self.normal_trash_balance > 0.50 or self.normal_water_balance > 0.50
  # end

  def status_name
    case self.statuskey
    when ACTIVE then 'აქტიური'
    when INACTIVE then 'გაუქმებული'
    when CLOSED then 'დახურული'
    else '?'
    end
  end

  def last_bill_date
    self.item_bills.last.billdate
  end

  def pay_period
    Bs::ConfigDefault.value(13, self.address.region.regionkey, self.custcatkey)
  end

  def eval_cut_date
    d1 = last_bill_date
    pay_period.business_days.after(d1)
  end

  def last_pay_date
    self.item_bills.last.lastday
  end

  def deposit_amount
    if self.deposit_customer and self.deposit_customer.active?
      return self.deposit_customer.start_depozit_amount
    else
      return 0
    end
  end

  def balance_fld
    balance = number_with_precision(self.balance, precision: 2, separator: '.', delimiter: ',')
    if self.deposit_amount > 0
      dep_balance = number_with_precision(self.deposit_amount, precision: 2, separator: '.', delimiter: ',')
      summary_balance = number_with_precision(self.balance + self.deposit_amount, precision: 2, separator: '.', delimiter: ',')
      [ "მიმდინარე: <code>#{balance}</code> GEL",
        "დეპოზიტი: <code>#{deposit_amount}</code> GEL",
        "ჯამური: <code>#{summary_balance}</code> GEL" ].join('<br>')
    else
      "<code>#{balance}</code> GEL"
    end
  end
end
