# -*- encoding : utf-8 -*-
class Call::Task
  include Mongoid::Document
  include Mongoid::Timestamps

  field :custkey, type: Integer
  field :complete, type: Boolean
  field :title, type: String
  field :body, type: String
  has_many :comments, class_name: 'Call::TaskComment'
  belongs_to :region, class_name: 'Ext::Region'
  belongs_to :user

  def customer
    Bs::Customer.where(custkey: self.custkey).first
  end

  def body_html
    self.body.gsub("\n", '<br>')
  end

end

class Call::TaskComment
  include Mongoid::Document
  include Mongoid::Timestamps

  field :text, type: String
  belongs_to :user
end
