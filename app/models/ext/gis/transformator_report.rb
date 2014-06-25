# -*- encoding : utf-8 -*-
class Ext::Gis::TransformatorReport
  include Mongoid::Document
  field :name, type: String
  field :count1, type: Integer
  field :count2, type: Integer
  field :sent, type: Boolean, default: false
end
