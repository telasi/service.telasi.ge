# -*- encoding : utf-8 -*-
class Ext::Gis::Fider
  include Mongoid::Document
  include Mongoid::Timestamps

  # gis part
  field :objectid, type: Integer
  field :account,  type: Integer
  field :station,  type: String
  field :voltage,  type: String
  field :section_number,  type: String
  field :number,   type: String
  belongs_to :section, class_name: 'Ext::Gis::Fider', inverse_of: :fider

  index :objectid
  index [[:station, Mongo::ASCENDING], [:voltage, Mongo::ASCENDING], [:number, Mongo::ASCENDING]]

end
