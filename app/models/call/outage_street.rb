# -*- encoding : utf-8 -*-
class Call::OutageStreet
  include Mongoid::Document
  belongs_to :outage, class_name: 'Call::Outage'
  field :region, type: String
  field :streetname, type: String
  field :count, type: Integer, default: 0
  index({ streetname: 1 })
end
