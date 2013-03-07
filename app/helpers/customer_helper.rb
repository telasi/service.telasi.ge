# -*- encoding : utf-8 -*-
module CustomerHelper

  def billoperation_class(operation)
    case operation.opertpkey
    when 1
      'item-power'
    when 2
      'item-estimate'
    when 3
      'item-money'
    when 4
      'item-voucher'
    when 5
      'item-subsidy'
    when 9
      'item-service'
    when 12
      'item-portion'
    else
      operation.opertpkey
    end
  end

end
