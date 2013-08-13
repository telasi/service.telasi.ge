# -*- encoding : utf-8 -*-
class Call::Status
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name,     type: String
  field :icon,     type: String
  field :order_by, type: Integer

  field :default,  type: Mongoid::Boolean, default: false
  field :open,     type: Mongoid::Boolean, default: false
  field :wait,     type: Mongoid::Boolean, default: false
  field :complete, type: Mongoid::Boolean, default: false
  field :canceled, type: Mongoid::Boolean, default: false

  def to_s
    self.name
  end

end
