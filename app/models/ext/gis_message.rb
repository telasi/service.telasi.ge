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
  has_many :logs, class_name: 'Ext::GisLog', inverse_of: :message

  def sync
    self.logs.each do |log|
      self.tp_count += 1
      obj = log.object
      if log.transformator?
        self.region_count  += obj.region_count
        self.street_count  += obj.street_count
        self.account_count += obj.account_count
      end
    end
    self.save
  end

  def sms_text
    text = self.on ? 'CarTva: ' : 'gaTiSva: '
    text += "#{self.tp_count} transformatori; #{self.street_count} quCa; #{self.account_count} abonenti."
    text
  end

end
