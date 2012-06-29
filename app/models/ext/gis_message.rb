# -*- encoding : utf-8 -*-
class Ext::GisMessage
  include Mongoid::Document
  include Mongoid::Timestamps
  has_many :logs, class_name: 'Ext::GisLog'
end
