# -*- encoding : utf-8 -*-
class Bs::Account < ActiveRecord::Base
  TYPE_SUBSTATION = 1
  TYPE_FEEDER = 2
  TYPE_TRANSF = 3
  TYPE_METER  = 4
  
  self.table_name  = 'bs.account'
  self.primary_key = :acckey
  belongs_to :customer,   class_name: 'Bs::Customer',      foreign_key: :custkey
  belongs_to :address,    class_name: 'Bs::Address',       foreign_key: :premisekey
  belongs_to :meter_type, class_name: 'Bs::MeterType',     foreign_key: :mttpkey
  has_one    :note,       class_name: 'Bs::Note',          foreign_key: :notekey
  has_many   :tariffs,    class_name: 'Bs::AccountTariff', foreign_key: :acckey, order: :acctarkey

  def status
    self.statuskey == 0 ? 'აქტიური' : 'გაუქმებული'
  end

  def account_type
    case self.acctype
    when TYPE_SUBSTATION
      'სადგური'
    when TYPE_FEEDER
      'ფიდერი'
    when TYPE_TRANSF
      'ტრანსფორმატორი'
    when TYPE_METER
      'მრიცხველი'
    else
      '?'
    end
  end

end
