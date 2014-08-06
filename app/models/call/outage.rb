# -*- encoding : utf-8 -*-
class Call::Outage
  include Mongoid::Document
  include Mongoid::Timestamps
  field :start, type: Date
  field :end, type: Date
  field :active, type: Boolean, default: true
  field :accnumb, type: String
  field :custkey, type: Integer
  field :streets, type: Array

  def customer; Bs::Customer.find(self.custkey) if self.custkey end
end
