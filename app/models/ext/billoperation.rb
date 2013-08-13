# -*- encoding : utf-8 -*-
class Ext::Billoperation
  include Mongoid::Document
  include Mongoid::Timestamps
  field :billoperkey, type: Integer
  field :opertpkey, type: Integer
  field :billopername, type: String
  field :description, type: String

  index({ billoperkey: 1 })

  def self.sync
    Bs::Billoperation.all.each do |op|
      oper = Ext::Billoperation.where(billoperkey: op.billoperkey).first || Ext::Billoperation.new(billoperkey: op.billoperkey)
      oper.opertpkey = op.opertpkey
      oper.billopername = op.billopername.strip.to_ka
      oper.save
    end
  end

end
