# -*- encoding : utf-8 -*-
class Call::Task
  include Mongoid::Document
  include Mongoid::Timestamps

  field :custkey, type: Integer
  field :title, type: String
  field :body, type: String
  has_many :comments, class_name: 'Call::TaskComment', order: :_id.desc
  belongs_to :status, class_name: 'Call::Status'
  belongs_to :region, class_name: 'Ext::Region'
  belongs_to :user

  def customer
    Bs::Customer.where(custkey: self.custkey).first
  end

  def body_html
    self.body.gsub("\n", '<br>')
  end

  def self.by_user(user)
    if user.all_regions
      where({})
    else
      where(:region_id.in => user.region_ids)
    end
  end

  def send_by(user)
    mobiles = Call::Mobiles.where(region_id: self.region.id).first
    if mobiles
      send_to(user, mobiles.mobile1) unless mobiles.mobile1.blank?
      send_to(user, mobiles.mobile2) unless mobiles.mobile2.blank?
    end
  end

  private

  def send_to(user, mobile)
    msg = Call::Sms.new(mobile: mobile, text: "აბ ##{self.customer.accnumb} (#{self.customer.address.to_s}): #{self.title}", user:user, task: self)
    Magti.send_sms(mobile, msg.text.to_lat) if Magti::SEND
    msg.save
  end

end
