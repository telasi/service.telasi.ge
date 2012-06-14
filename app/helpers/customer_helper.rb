# -*- encoding : utf-8 -*-
module CustomerHelper

  def trash_balance(customer)
    customer.trash_customer ? customer.trash_customer.curr_balance : nil
  end

  def water_balance(customer)
    water_item = customer.water_items.last
    water_item ? water_item.new_balance : nil
  end

  def cut_candidate(item_bill)
    if item_bill
      customer = item_bill.customer
      customer.balance > 0.50 or (trash_balance(customer) || 0) > 0.50 or (water_balance(customer) || 0) > 0.50
    else
      false
    end
  end

end
