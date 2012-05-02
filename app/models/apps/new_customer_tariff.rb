# -*- encoding : utf-8 -*-
require 'yaml'

# ახალი აბონენტის გახსნის ტარიფი.
class Apps::NewCustomerTariff
  attr_accessor :id
  attr_accessor :voltage, :voltage_alt
  attr_accessor :power_from, :power_to
  attr_accessor :days_to_complete
  attr_accessor :price_gel

  @@tariffs = []
  class << self
    # ტარიფების ინიციალიზაცია.
    def init_tariffs
      YAML.load_file('config/new-customer-tariff.yml').values.each do |t|
        tariff = Apps::NewCustomerTariff.new
        tariff.id = t['id'].to_i
        tariff.voltage = t['voltage']
        tariff.voltage_alt = t['voltage_alt']
        tariff.days_to_complete = t['days_to_complete'].to_i
        tariff.price_gel = t['price_gel'].to_f
        tariff.power_from, tariff.power_to = t['power_kwt'].split('-').map{|p| p.to_i}
        @@tariffs << tariff
      end
    end

    # ტარიფების სიის მიღება.
    def tariffs
      init_tariffs if @@tariffs.empty?
      @@tariffs
    end
  end

#	id: 1
#  voltage: '0.220'
#  voltage_alt: '220 ვ'
#  power_kwt: 1-10
#  days_to_complete: 35
#  price_gel: 400

end
