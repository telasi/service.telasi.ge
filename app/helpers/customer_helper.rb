# -*- encoding : utf-8 -*-
module CustomerHelper

  def balance(customer)
    customer.balance - (customer.pre_payment || 0)
  end

  def trash_balance(customer)
    customer.trash_customer ? (customer.trash_customer.curr_balance - (customer.pre_trash_payment || 0)) : 0
  end

  def water_balance(customer)
    water_item = customer.water_items.last
    (water_item ? water_item.new_balance : 0) - (customer.pre_water_payment || 0)
  end

  def cut_candidate(item_bill)
    if item_bill
      customer = item_bill.customer
      balance(customer) > 0.50 or trash_balance(customer) > 0.50 or water_balance(customer) > 0.50
    else
      false
    end
  end

end
