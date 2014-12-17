# -*- encoding : utf-8 -*-
class Gis::SummaryReceiver
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name,    type: String
  field :active,  type: Boolean, default: true
  field :locale,  type: String,  default: 'ka'
  field :mobile,  type: String
  field :groups,  type: String
  field :note,    type: String
  index({ active: 1, name: 1 })
  validates_presence_of :name, :locale, :mobile, :groups

  def self.active
    Gis::SummaryReceiver.where(active: true)
  end
end
