# -*- encoding : utf-8 -*-
class Apps::NewCustomerCalculation
  include Mongoid::Document
  field :voltage,   type: String
  field :power,     type: Float
  field :tariff_id, type: Integer
  field :amount,    type: Float
  field :error,     type: String
  embedded_in :application, class_name: 'Apps::NewCustomerApplication', inverse_of: :calculations
end