# -*- encoding : utf-8 -*-
class Ext::Region
  include Mongoid::Document
  include Mongoid::Timestamps
  include Telasi::StandardPhoto

  field :regionkey, type: Integer
  field :type,      type: Integer
  field :name,      type: String
  field :address,   type: String
  field :phone,     type: String
  field :phone_exp, type: String
  field :latitude,  type: Float, default: 41.7341651833187
  field :longitude, type: Float, default: 44.78496193885803
  field :show_on_map,  type: Boolean, default: false
  field :trash_office, type: Boolean, default: false

  def self.sync
    Bs::Region.where(regtpkey: 2).each do |reg|
      if reg.regionname.index('/').nil? and reg.regionkey < 400
        region = Ext::Region.where(regionkey: reg.regionkey).first || Ext::Region.new(regionkey: reg.regionkey)
        region.type = reg.regtpkey
        region.name = reg.regionname.to_ka.strip
        region.address = reg.address unless region.address
        region.phone = reg.phone unless region.phone
        region.save
      end
    end
  end

  def to_s; self.name end
end
