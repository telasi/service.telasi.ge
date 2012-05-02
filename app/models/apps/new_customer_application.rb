# -*- encoding : utf-8 -*-

# ახალი აბონენტის მიერთების განაცხადი.
class Apps::NewCustomerApplication
  VOLTAGE_220 = '0.220'
  VOLTAGE_380 = '0.380'
  VOLTAGE_610 = '6/10'
  VOLTAGES = [VOLTAGE_220, VOLTAGE_380, VOLTAGE_610]
  VOLTAGES_HUMAN = {'220 ვ' => VOLTAGE_220, '380 ვ' => VOLTAGE_380, '6/10 კვ' => VOLTAGE_610}

  # საწყისი სტატუსი.
  STATUS_INITIAL  = 0

  # დავალება გაგზავნილია.
  STATUS_SENT     = 1

  # დავალებაა არაა მიღებული.
  STATUS_CANCELED = 2

  # დავალება მიღებულია.
  STATUS_RECEIVED = 3

  # დავალება დასრულებულია.
  STATUS_COMPLETE = 4

  include Mongoid::Document
  field :status, type: Integer, default: STATUS_INITIAL
  field :voltage, type: String
  field :power, type: Float
  field :tariff, type: Integer
  embedded_in :application, :class_name => 'Apps::Application'
end
