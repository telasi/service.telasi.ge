# -*- encoding : utf-8 -*-
class Call::Mobiles
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :region, class_name: 'Ext::Region'
  field :mobile1, type: String
  field :mobile2, type: String

  def self.sync
    Ext::Region.all.each do |r|
      mobile = Call::Mobiles.where(region_id: r.id).first || Call::Mobiles.new(region_id: r.id)
      mobile.save
    end
  end

end
