# -*- encoding : utf-8 -*-
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
  field :status,  type: Integer, default: STATUS_INITIAL
  field :voltage, type: String
  field :amount,  type: Float
  field :days,    type: Integer
  embedded_in :application, :class_name => 'Apps::Application'
  embeds_many :items, class_name: 'Apps::NewCustomerItem', inverse_of: :application
  embeds_many :calculations, class_name: 'Apps::NewCustomerCalculation', inverse_of: :application

  # ტარიფის გათვლა.
  def calculate
    self.calculations.destroy_all
    self.amount = 0
    self.days = 0
    VOLTAGES.each do |v|
      items = self.items.where(voltage: v)
      power = items.inject(0){ |sum, x| sum + x[:power] }
      tariff = Apps::NewCustomerTariff.tariff_for(v, power)
      if tariff
        if power > 0
          self.calculations << Apps::NewCustomerCalculation.new(voltage: v, power: power, tariff_id: tariff.id, amount: tariff.price_gel, days: tariff.days_to_complete)
          self.amount += tariff.price_gel unless self.amount.nil?
          self.days = tariff.days_to_complete if self.days < tariff.days_to_complete
        end
      else
        if power > 0
          self.calculations << Apps::NewCustomerCalculation.new(voltage: v, power: power, tariff_id: nil)
          self.amount = nil
        end
      end
    end
    self.save
  end

end
