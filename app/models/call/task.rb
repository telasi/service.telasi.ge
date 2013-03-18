# -*- encoding : utf-8 -*-
class Call::Task
  include Mongoid::Document
  include Mongoid::Timestamps

  field :custkey, type: Integer
  field :title, type: String
  field :body, type: String
  has_many :comments, class_name: 'Call::TaskComment', order: :_id.desc
  belongs_to :status, class_name: 'Ext::Status'
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

end
