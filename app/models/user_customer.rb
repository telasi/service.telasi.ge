# -*- encoding : utf-8 -*-
class UserCustomer
  include Mongoid::Document
  include Mongoid::Timestamps

  field :accnumb,    type: String
  field :custkey,    type: Integer
  field :custname,   type: String
  field :notify_sms, type: Boolean, default: true
  field :last_balance,       type: Float
  field :last_trash_balance, type: Float
  field :last_water_balance, type: Float

  belongs_to :user, inverse_of: :customers

  before_create  :on_before_create
  before_destroy :on_before_destroy

  def self.notify
    UserCustomer.all.each do |cust|
      bs_cust = Bs::Customer.where(custkey: cust.custkey).first
      # electricity
      if bs_cust.normal_balance > cust.last_balance
        Magti.send_sms cust.mobile, "ab. ##{cust.accnumb} // Tqveni vali gaizarda: #{C12.number_format bs_cust.normal_balance} GEL"
      elsif bs_cust.normal_balance < cust.last_balance
        Magti.send_sms cust.mobile, "ab. ##{cust.accnumb} // Tqveni vali Semcirda: #{C12.number_format bs_cust.normal_balance} GEL"
      end
      # trash
      if bs_cust.normal_trash_balance > cust.last_trash_balance
        Magti.send_sms cust.mobile, "ab. ##{cust.accnumb} // Tqveni dasufTavebis vali gaizarda: #{C12.number_format bs_cust.normal_trash_balance} GEL"
      elsif bs_cust.normal_trash_balance < cust.last_trash_balance
        Magti.send_sms cust.mobile, "ab. ##{cust.accnumb} // Tqveni dasufTavebis vali Semcirda: #{C12.number_format bs_cust.normal_trash_balance} GEL"
      end
      # water
      if bs_cust.normal_water_balance > cust.last_water_balance
        Magti.send_sms cust.mobile, "ab. ##{cust.accnumb} // Tqveni wylis vali gaizarda: #{C12.number_format bs_cust.normal_water_balance} GEL"
      elsif bs_cust.normal_water_balance < cust.last_water_balance
        Magti.send_sms cust.mobile, "ab. ##{cust.accnumb} // Tqveni wylis vali Semcirda: #{C12.number_format bs_cust.normal_water_balance} GEL"
      end
      # update balances
      cust.last_balance = bs_cust.normal_balance
      cust.last_trash_balance = bs_cust.normal_trash_balance
      cust.last_water_balance = bs_cust.normal_water_balance
      cust.save
    end if Magti::SEND
  end

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
