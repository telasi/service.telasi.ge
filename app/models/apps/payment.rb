# -*- encoding : utf-8 -*-
class Apps::Payment
  include Mongoid::Document
  include Mongoid::Timestamps
  field :date, type: Date
  field :amount, type: Float
  field :comment, type: String
  belongs_to :application, class_name: 'Apps::Application'

  validates_presence_of :date, message: 'ჩაწერეთ თარიღი'
  validates_numericality_of :amount, message: 'ჩაწერეთ თანხა'
end
