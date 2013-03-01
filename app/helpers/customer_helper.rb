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

  def account_properties(acc)
    properties_table acc,
      title: 'ანგარიში და მრიცხველი', icon: 'fff/cog.png',
      col1: {
        accid: {label: 'ანგარიში', tag: 'code'},
        address: 'მისამართი',
        inst_cp: { label: 'დადგმ. სიმძლავრე', tag: 'code', digits: 0, post: 'kWh' },
        'meter_type.mtname' => 'მრიცხველი',
        mtnumb: { label: 'მრიცხველის №', tag: 'code' },
        mtkoef: { label: 'კოეფიციენტი', tag: 'code'},
        'meter_type.digit' => {label: 'თანრიგი', tag: 'code' },
      },
      col2: {
        mainaccount: 'ძირითადი ანგარიში?',
        status: 'სტატუსი',
        createdate: 'შექმნილია',
        closedate: 'დახურვის თარიღი',
        note: 'შენიშვნა'
      }
  end

end
