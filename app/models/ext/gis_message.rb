# -*- encoding : utf-8 -*-
class Ext::GisMessage
  include Mongoid::Document
  include Mongoid::Timestamps
  field :on, type: Boolean
  has_many :logs, class_name: 'Ext::GisLog', inverse_of: :message
end
