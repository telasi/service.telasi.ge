# -*- encoding : utf-8 -*-
class Call::Outage
  include Mongoid::Document
  include Mongoid::Timestamps

  CATEGORIES = { 'გეგმიური' => 1, 'ავარიული' => 2 }
  NAMES = CATEGORIES.invert

  field :start_date, type: String, default: Date.today
  field :start_time, type: String, default: '00:00'
  field :end_date, type: String, default: Date.today
  field :end_time, type: String, default: '00:00'
  field :active, type: Boolean, default: true
  field :accnumb, type: String
  field :custkey, type: Integer
  field :category, type: Integer
  field :description, type: String
  has_many :streets, class_name: 'Call::OutageStreet'

  validates_presence_of :start_date, message: 'საწყისი თარიღი აუცილებელია'
  validates_presence_of :start_time, message: 'საწყისი დრო აუცილებელია'
  validates_presence_of :end_date, message: 'საწყისი თარიღი აუცილებელია'
  validates_presence_of :end_time, message: 'საწყისი დრო აუცილებელია'
  validate :customer_presence

  after_create :on_after_create
  before_update :on_before_update
  before_save :on_before_save

  index({ active: 1 })

  def customer; Bs::Customer.find(self.custkey) if self.custkey end
  def start; "#{Date.strptime(self.start_date).strftime('%d/%m/%Y')} #{self.start_time}" rescue "#{self.start_date} #{self.start_time}" end
  def end; "#{Date.strptime(self.end_date).strftime('%d/%m/%Y')} #{self.end_time}" rescue "#{self.end_date} #{self.end_time}" end
  def category_name; NAMES[self.category] end

  protected

  def find_customer; Bs::Customer.where(accnumb: self.accnumb.to_lat).first end
  def customer_presence; errors.add(:accnumb, 'ასეთი აბონენტი ვერ მოიძებნა') if find_customer.blank? end
  def on_before_save; self.custkey = find_customer.custkey if self.accnumb_changed? end

  def on_after_create
    customer = find_customer
    customer.accounts.each do |acc|
      relations = Bs::Accrel.where(base_acckey: acc.acckey)
      relations.each do |rel|
        address = rel.account.address
        street = address.street.streetname.to_ka
        str = self.streets.where(streetname: street).first || Call::OutageStreet.new(outage: self, streetname: street)
        str.count += 1 ; str.region = address.region.regionname.to_ka
        str.save
      end
    end
  end

  def on_before_update
    on_after_create if self.accnumb_changed?
  end
end
