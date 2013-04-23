# -*- encoding : utf-8 -*-
class Call::RegionData
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :region, class_name: 'Ext::Region'
  field :mobile1, type: String
  field :mobile2, type: String
  field :cutbase, type: String

  def region_status
    clazz = self.cutbase.constantize
    clazz.count > 0
  rescue
    false
  end

  def self.sync
    Ext::Region.all.each do |r|
      region = Call::RegionData.where(region_id: r.id).first
      region ||= Call::RegionData.new(region_id: r.id, mobile1: '595335514', mobile2: '595335514')
      region.save
    end
  end

end
