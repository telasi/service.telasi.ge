# -*- encoding : utf-8 -*-
module CustomerHelper

  def trash_balance(customer)
    if customer.trash_customer
      C12.number_format customer.trash_customer.curr_balance
    else
      '--'
    end
  end

  def water_balance(customer)
    water_item = customer.water_items.last
    if water_item
      C12.number_format water_item.new_balance
    else
      '--'
    end
  end

end