# -*- encoding : utf-8 -*-
class Call::Status
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name,     type: String
  field :icon,     type: String
  field :order_by, type: Integer

  field :default,  type: Boolean, default: false
  field :open,     type: Boolean, default: false
  field :wait,     type: Boolean, default: false
  field :complete, type: Boolean, default: false
  field :canceled, type: Boolean, default: false

  def to_s
    self.name
  end

end
