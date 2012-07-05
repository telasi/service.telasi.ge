# -*- encoding : utf-8 -*-
class Ext::Gis::Section
  include Mongoid::Document
  include Mongoid::Timestamps

  # gis part
  field :objectid, type: Integer
  field :account,  type: Integer
  field :station,  type: String
  field :voltage,  type: String
  field :number,  type: String

  index :objectid
  index [[:station, Mongo::ASCENDING], [:voltage, Mongo::ASCENDING], [:number, Mongo::ASCENDING]]

end
