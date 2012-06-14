# -*- encoding : utf-8 -*-
class Bs::Customer < ActiveRecord::Base
  self.table_name  = 'bs.customer'
  self.primary_key = :custkey
  belongs_to :address,      class_name: 'Bs::Address',       foreign_key: :premisekey
  has_one  :trash_customer, class_name: 'Bs::TrashCustomer', foreign_key: :custkey
  has_many :water_items,    class_name: 'Bs::WaterItem',     foreign_key: :custkey, order: 'year, month'
  has_many :item_bills,     class_name: 'Bs::ItemBill',      foreign_key: :custkey, order: 'itemkey'

  def pre_payment
    Bs::Payment.where('paydate > ? AND custkey = ? AND status = 1', Date.today - 7, self.custkey).inject(0) do |sum, payment|
      sum += payment.amount
    end
  end

  def pre_trash_payment
    Bs::TrashPayment.where('paydate > ? AND custkey = ? AND status = 1', Date.today - 7, self.custkey).inject(0) do |sum, payment|
      sum += payment.amount
    end
  end

  def pre_water_payment
    # XXXX: status
    # Bs::WaterPayment.where('paydate > ? AND custkey = ?', Date.today - 7, self.custkey).inject(0) do |sum, payment|
    #   sum += payment.payamount
    # end
    0
  end

end
