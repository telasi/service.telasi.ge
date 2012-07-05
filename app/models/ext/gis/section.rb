# -*- encoding : utf-8 -*-
class Ext::Gis::Section
  include Mongoid::Document
  include Mongoid::Timestamps

  # gis part
  field :objectid, type: Integer
  field :account,  type: Integer
  field :station,  type: String
  field :voltage,  type: String
  field :number,   type: String

  index :objectid
  index [[:station, Mongo::ASCENDING], [:voltage, Mongo::ASCENDING], [:number, Mongo::ASCENDING]]

  def self.sync
    Gis::Section.all.each do |gis_sec|
      sec = Ext::Gis::Section.where(objectid: gis_sec.objectid).first || Ext::Gis::Section.new(objectid: gis_sec.objectid)
      sec.account = gis_sec.account
      sec.station = gis_sec.station.to_ka(true)
      sec.voltage = gis_sec.kv
      sec.number  = gis_sec.barsection.to_ka(true)
      sec.save
    end
  end

end
