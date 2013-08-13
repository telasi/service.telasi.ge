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
  STATUS_DEPROVED = 2

  # დავალება მიღებულია.
  STATUS_APPROVED = 3

  # დავალება დასრულებულია.
  STATUS_COMPLETE = 4

  include Mongoid::Document
  field :status,  type: Integer, default: STATUS_INITIAL
  field :voltage, type: String
  field :amount,  type: Float
  field :days,    type: Integer
  field :need_resolution, type: Mongoid::Boolean, default: true
  field :send_date,    type: Time
  field :approve_date, type: Time
  field :deprove_date, type: Time
  field :complete_date, type: Time
  embedded_in :application,  class_name: 'Apps::Application'
  embeds_many :items,        class_name: 'Apps::NewCustomerItem',        inverse_of: :application
  embeds_many :calculations, class_name: 'Apps::NewCustomerCalculation', inverse_of: :application

  def initial?
    self.status == STATUS_INITIAL
  end

  def sent?
    self.status == STATUS_SENT
  end

  def approved?
    self.status == STATUS_APPROVED
  end

  def deproved?
    self.status == STATUS_DEPROVED
  end

  def complete?
    self.status == STATUS_COMPLETE
  end

  # განაცხადის გაგზავნა თელასში.
  def send!
    return false unless self.initial?
    return false unless self.amount
    prev = Apps::Application.where(:"new_customer_application.status".ne => STATUS_INITIAL).desc(:number).first
    self.application.number = (prev.nil? ? 0 : prev.number) + 1
    self.application.private = false
    self.send_date = Time.now
    if self.application.save
      self.status = STATUS_SENT
      self.save
    end
  end

  # განცხადების "დადასტურება".
  def approve!
    return false unless self.sent?
    self.status = STATUS_APPROVED
    self.approve_date = Time.now
    self.save
  end

  # განცხადების "უარყოფა".
  def deprove!
    return false unless self.sent?
    self.status = STATUS_DEPROVED
    self.deprove_date = Time.now
    self.save
  end

  # განცხადების მობრუნება წარმოებაში.
  def to_sent!
    return false unless self.approved? or self.deproved? or self.complete?
    self.status = STATUS_SENT
    self.save
  end

  # განცხადების "დასრულება".
  def complete!
    return false unless self.approved?
    self.status = STATUS_COMPLETE
    self.complete_date = Time.now
    self.save
  end

  # ტარიფის გათვლა.
  def calculate
    self.calculations.destroy_all
    self.amount = 0
    self.days   = 0
    calc_220_in_380 = cnt(VOLTAGE_220) > 2
    calculate_voltage(VOLTAGE_220) unless calc_220_in_380
    calculate_voltage(VOLTAGE_380, calc_220_in_380) 
    calculate_voltage(VOLTAGE_610)
    self.save
    self.application.recalculate!
  end

  def count_by_use(use = nil)
    rel = use.nil? ? self.items : self.items.where(use: use)
    rel.inject(0){ |cnt, x| cnt + (x.tin.blank? ? x.count : 1) }
  end

  def power
    self.items.inject(0){ |pw, x| pw + x.power }
  end

  private

  def cnt(volt)
    self.items.where(voltage: volt).inject(0){ |cnt, x| cnt + (x.tin.blank? ? x.count : 1) }
  end

  def calculate_voltage(volt, with_220 = false)
    items = self.items.where(voltage: volt)
    items += self.items.where(voltage: VOLTAGE_220) if with_220
    if volt == VOLTAGE_220
      count = cnt(volt)
      count += cnt(VOLTAGE_220) if with_220
    else
      count = 1
    end
    power = items.inject(0){ |sum, x| sum + x[:power] * ( volt == VOLTAGE_220 && x.tin.nil? ? x.count : 1 ) }
    if volt == VOLTAGE_220
      tariff = nil
      items.each do |item|
        tariff = Apps::NewCustomerTariff.tariff_for(volt, item.power)
        break if tariff.nil?
      end
    else
      tariff = Apps::NewCustomerTariff.tariff_for(volt, power)
    end
    # calculate amount
    if tariff
      if power > 0
        tariff_days = self.need_resolution ? tariff.days_to_complete : tariff.days_to_complete_without_resolution
        self.calculations << Apps::NewCustomerCalculation.new(voltage: volt, power: power, tariff_id: tariff.id, amount: tariff.price_gel * count, days: tariff_days)
        self.amount += tariff.price_gel * count unless self.amount.nil?
        self.days = tariff_days if self.days < tariff_days
      end
    else
      if power > 0
        self.calculations << Apps::NewCustomerCalculation.new(voltage: volt, power: power, tariff_id: nil)
        self.amount = nil
      end
    end
  end

end
