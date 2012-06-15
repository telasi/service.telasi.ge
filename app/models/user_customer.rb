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

  before_create  :on_before_create
  before_destroy :on_before_destroy

  private

  def on_before_create
    self.user.accnumbs = [] unless self.user.accnumbs
    self.user.accnumbs << self.accnumb unless self.user.accnumbs.include?(self.accnumb)
    self.user.save
  end

  def on_before_destroy
    self.user.accnumbs.delete(self.accnumb)
    self.user.save
  end

end
