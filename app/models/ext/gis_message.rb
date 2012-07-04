# -*- encoding : utf-8 -*-
class Ext::GisMessage
  include Mongoid::Document
  include Mongoid::Timestamps
  field :on, type: Boolean
  field :sent, type: Boolean, default: false
  field :tp_count, type: Integer, default: 0
  field :region_count, type: Integer, default: 0
  field :street_count, type: Integer, default: 0
  field :account_count, type: Integer, default: 0
  field :regionkeys, type: Array, default: []
  has_many :logs, class_name: 'Ext::GisLog', inverse_of: :message

  def sync
    self.logs.each do |log|
      self.tp_count += 1
      if log.transformator?
        transformator = log.object
        self.street_count  += transformator.street_count
        self.account_count += transformator.account_count
        self.regionkeys << transformator.regionkey unless self.regionkeys.include?(transformator.regionkey)
      end
    end
    self.save
  end

  def sms_text
    text = self.on ? 'CarTva: ' : 'gaTiSva: '
    if self.regionkeys.size == 1
      region = Bs::Region.find(self.regionkey.first)
      text += %Q{biznes centri "#{region.regionname.to_lat}"; }
    else
      text += "#{self.regionkeys.size} biznes centri; "
    end
    text += "#{self.tp_count} transformatori; #{self.street_count} quCa; #{self.account_count} abonenti."
    text
  end

end
