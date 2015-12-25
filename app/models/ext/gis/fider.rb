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
  belongs_to :section, class_name: 'Ext::Gis::Fider', inverse_of: :fiders

  index({ objectid: 1 })
  index({ station: 1, voltage: 1, number: 1 })

  def to_s
    "#{station} #{voltage} კვ, სექცია #{section_number}, ფიდერი #{number}"
  end
end
