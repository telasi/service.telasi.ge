# -*- encoding : utf-8 -*-
class Call::Category
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name,     type: String
  field :order_by, type: Integer
  validates_presence_of :name, message: 'ჩაწერეთ დასახელება'
  validates_numericality_of :order_by, message: 'ჩაწერეთ ციფრი'

  def to_s; self.name end
end
