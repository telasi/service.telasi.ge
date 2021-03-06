# -*- encoding : utf-8 -*-
class Apps::NewCustomerItem
  include Mongoid::Document
  include Mongoid::Timestamps
  include Telasi::CheckTin

  TYPE_SUMMARY = 'summary'
  TYPE_DETAIL  = 'detail'

  USE_PERSONAL = 0
  USE_NOT_PERSONAL = 1
  USE_SHARED = 2

  field :type,    type: String
  field :address, type: String
  field :address_code, type: String
  field :voltage, type: String
  field :power,   type: Float
  field :use,     type: Integer, default: USE_PERSONAL
  field :count,   type: Integer
  field :tin,     type: String
  field :name,    type: String
  field :comment, type: String
  embedded_in :application, class_name: 'Apps::NewCustomerApplication', inverse_of: :items

  validates_presence_of :type
  validates_presence_of :address, message: 'ჩაწერეთ მისამართი.'
  validates_presence_of :address_code, message: 'ჩაწერეთ საკადასტრო კოდი.'
  validates_presence_of :voltage
  validates_numericality_of :power, message: 'ჩაწერეთ სწორი რიცხვითი მნიშვნელობა.'

  validate :validate_type
  validate :validate_power
  before_save :on_before_save

  def quick_amount
    Apps::NewCustomerTariff.tariff_for(self.voltage, self.power).price_gel
  end

  def vol220?
    self.voltage == Apps::NewCustomerApplication::VOLTAGE_220
  end

  def vol380?
    self.voltage == Apps::NewCustomerApplication::VOLTAGE_380
  end

  def vol610?
    self.voltage == Apps::NewCustomerApplication::VOLTAGE_610
  end

  def personal_use
    self.use == USE_PERSONAL
  end

  private

  def validate_type
    if self.type == TYPE_DETAIL
      errors.add(:tin, 'ჩაწერეთ საიდენტიფიკაციო ნომერი') if self.tin.blank?
    end
  end

  def validate_power
    errors.add(:power, 'სიმძლავრე უნდა იყოს მეტი 0-ზე.') if self.power.nil? or self.power <= 0
  end

  def on_before_save
    if self.type == TYPE_DETAIL
      self.count = 0
    else
      self.tin = nil
      self.name = nil
      self.count = 1 if self.count.nil? or self.count <= 0
    end
  end

end
