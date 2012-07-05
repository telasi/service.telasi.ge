# -*- encoding : utf-8 -*-
class Gis::Receiver
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name,       type: String
  field :active,     type: Boolean
  field :email_on,   type: String
  field :email_off,  type: String
  field :mobile_on,  type: String
  field :mobile_off, type: String
  index :name
end