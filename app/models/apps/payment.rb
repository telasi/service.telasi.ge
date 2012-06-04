# -*- encoding : utf-8 -*-
class Apps::Payment
  include Mongoid::Document
  include Mongoid::Timestamps
  field :date, type: Date
  field :amount, type: Float
  belongs_to :application, class_name: 'Apps::Application'
end