# -*- encoding : utf-8 -*-
class Bs::Tariff < ActiveRecord::Base
  self.table_name  = 'bs.tarcomp'
  self.primary_key = :compkey
  has_many :steps, class_name: 'Bs::TariffStep', foreign_key: :ts_tar_key, order: :ts_seq
end
