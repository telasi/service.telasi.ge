# -*- encoding : utf-8 -*-
class Bs::Account < ActiveRecord::Base
  self.table_name  = 'bs.account'
  self.primary_key = :acckey
  belongs_to :customer,   class_name: 'Bs::Customer',  foreign_key: :custkey
  belongs_to :address,    class_name: 'Bs::Address',   foreign_key: :premisekey
  belongs_to :meter_type, class_name: 'Bs::MeterType', foreign_key: :mttpkey
  has_one    :note,       class_name: 'Bs::Note',      foreign_key: :notekey

  def status
    self.statuskey == 0 ? 'აქტიური' : 'გაუქმებული'
  end

end
