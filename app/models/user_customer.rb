# -*- encoding : utf-8 -*-
class UserCustomer
  include Mongoid::Document
  include Mongoid::Timestamps

  field :accnumb,    type: String
  field :custkey,    type: Integer
  field :custname,   type: String
  field :notify_sms, type: Boolean, default: true
  field :last_balance,       type: Float, default: 0
  field :last_trash_balance, type: Float, default: 0
  field :last_water_balance, type: Float, default: 0

  belongs_to :user, inverse_of: :customers

end
