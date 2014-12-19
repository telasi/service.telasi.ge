# -*- encoding : utf-8 -*-
class Gis::SummaryReport
  include Mongoid::Document
  include Mongoid::Timestamps
  field :groupid, type: Integer
  field :mobiles, type: String
  field :text,    type: String
  field :sent,    type: Boolean
end
