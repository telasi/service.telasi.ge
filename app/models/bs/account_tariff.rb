# -*- encoding : utf-8 -*-
class Bs::AccountTariff < ActiveRecord::Base
  self.table_name  = 'bs.acctariffs'
  self.primary_key = :acctarkey
  belongs_to :account, class_name: 'Bs::Account', foreign_key: :acckey
  belongs_to :tariff, class_name: 'Bs::Tariff', foreign_key: :compkey
end
