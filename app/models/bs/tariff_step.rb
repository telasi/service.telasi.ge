# -*- encoding : utf-8 -*-
class Bs::TariffStep < ActiveRecord::Base
  self.table_name  = 'bs.tariff_step'
  self.primary_key = :ts_key
  belongs_to :tariff, class_name: 'Bs::Tariff', foreign_key: :ts_tar_key
end
