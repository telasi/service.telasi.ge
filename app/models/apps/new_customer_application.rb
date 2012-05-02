# -*- encoding : utf-8 -*-

# ახალი აბონენტის მიერთების განაცხადი.
class Apps::NewCustomerApplication
  VOLTAGE_220 = '0.220'
  VOLTAGE_380 = '0.380'
  VOLTAGE_610 = '6/10'
  VOLTAGES = [VOLTAGE_220, VOLTAGE_380, VOLTAGE_610]

  include Mongoid::Document
  embedded_in :application, :class_name => 'Apps::Application'
end
