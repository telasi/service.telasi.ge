# -*- encoding : utf-8 -*-
class Call::Outage
  include Mongoid::Document
  include Mongoid::Timestamps
  field :start_date, type: String, default: Date.today
  field :start_time, type: String, default: '00:00'
  field :end_date, type: String, default: Date.today
  field :end_time, type: String, default: '00:00'
  field :active, type: Boolean, default: true
  field :accnumb, type: String
  field :custkey, type: Integer
  has_many :streets, class_name: 'Call::OutageStreet'

  validates_presence_of :start_date, message: 'საწყისი თარიღი აუცილებელია'
  validates_presence_of :start_time, message: 'საწყისი დრო აუცილებელია'
  validates_presence_of :end_date, message: 'საწყისი თარიღი აუცილებელია'
  validates_presence_of :end_time, message: 'საწყისი დრო აუცილებელია'
  validate :customer_presence

  after_save :on_after_save

  index({ active: 1 })

  def customer; Bs::Customer.find(self.custkey) if self.custkey end

  protected

  def find_customer; Bs::Customer.where(accnumb: self.accnumb.to_lat).first end

  def customer_presence; errors.add(:accnumb, 'ასეთი აბონენტი ვერ მოიძებნა') if find_customer.blank? end

  def on_after_save
    customer = find_customer
    self.custkey = customer.custkey
    customer.accounts.each do |acc|
      relations = Bs::Accrel.where(base_acckey: acc.acckey)
      relations.each do |rel|
        address = rel.account.address
        street = address.street.streetname
        str = self.streets.where(streetname: street).first || Call::OutageStreet.new(outage: self, streetname: street)
        str.count += 1 ; str.region = address.region.regionname
        str.save
      end
    end
  end
end

