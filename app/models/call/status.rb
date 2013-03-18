# -*- encoding : utf-8 -*-
class Call::Status
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name,     type: String
  field :icon,     type: String
  field :default,  type: Boolean
  field :open,     type: Boolean
  field :order_by, type: Integer

  def to_s
    self.name
  end

end
