# -*- encoding : utf-8 -*-
class Call::Category
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name,     type: String
  field :order_by, type: Integer

  def to_s; self.name end
end
