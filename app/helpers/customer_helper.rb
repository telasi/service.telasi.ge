# -*- encoding : utf-8 -*-
module CustomerHelper

  def billoperation_class(operation)
    case operation.opertpkey
    when 1
      'power'
    when 2
      'estimate'
    when 3
      'money'
    when 4
      'voucher'
    when 5
      'subsidy'
    when 9
      'service'
    when 12
      'portion'
    else
      operation.opertpkey
    end
  end

end