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
  has_many :fiders, class_name: 'Ext::Gis::Fider', inverse_of: :section, order: 'number'

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
      Gis::Fider.where(station: gis_sec.station, kv: gis_sec.kv, barsection: gis_sec.barsection).order(:fider).each do |gis_fider|
        fider = Ext::Gis::Fider.where(objectid: gis_fider.objectid).first || Ext::Gis::Fider.new(objectid: gis_fider.objectid)
        fider.account = gis_fider.account
        fider.station = gis_fider.station.to_ka(true)
        fider.voltage = gis_fider.kv
        fider.section_number = gis_fider.barsection.to_ka(true)
        fider.number  = gis_fider.fider
        fider.section = sec
        fider.save
      end
    end
  end

  def to_s
    "#{station} #{voltage} კვ, სექცია #{number}"
  end

end
