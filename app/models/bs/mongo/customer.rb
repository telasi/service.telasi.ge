# -*- encoding : utf-8 -*-
class Bs::Mongo::Customer
  include Mongoid::Document
  include Mongoid::Timestamps
  store_in 'bs_customer'

  field :custkey, type: Integer
  embeds_one :address, class_name: 'Bs::Mongo::Address'
  embeds_one :send_address, class_name: 'Bs::Mongo::Address'
  embeds_one :category, class_name: 'Bs::Mongo::CustomerCategory'
  embeds_one :activity, class_name: 'Bs::Mongo::CustomerCategory'
  field :note, type: String
  field :accnumb, type: String
  field :custname, type: String
  field :comercial, type: String
  field :createdate, type: Date
  field :closedate, type: Date
  field :tel, type: String
  field :fax, type: String
  field :email, type: String
  field :taxid, type: String
  field :contact, type: String
  field :balance, type: Float
  field :old_balance, type: Float
  field :illegalline, type: Mongoid::Boolean
  field :except, type: Mongoid::Boolean
  field :goodpayer, type: Mongoid::Boolean
  field :payint, type: Integer
  field :cut, type: Mongoid::Boolean
  field :statuskey, type: Integer

  def self.sync!(data)
    if data.is_a? Integer
      custkey = data
      bs_customer = Bs::Customer.where(custkey: custkey).first
    else
      custkey = data.custkey
      bs_customer = data
    end
    cust = Bs::Mongo::Customer.where(custkey: custkey).first || Bs::Mongo::Customer.new(custkey: custkey)
    cust.address = create_address(bs_customer.address)
    cust.send_address = create_address(bs_customer.send_address)
    cust.accnumb = bs_customer.accnumb.to_ka
    cust.custname = bs_customer.custname.to_ka
    cust.comercial = bs_customer.commercial.blank? ? nil : bs_customer.commercial.strip.to_ka
    cust.createdate = bs_customer.createdate
    cust.closedate = bs_customer.closedate
    cust.tel = bs_customer.tel.blank? ? nil : bs_customer.tel.strip.to_ka
    cust.fax = bs_customer.fax.blank? ? nil : bs_customer.fax.strip.to_ka
    cust.email = bs_customer.email.blank? ? nil : bs_customer.email.strip.to_ka
    cust.taxid = bs_customer.taxid.blank? ? nil : bs_customer.taxid.strip.to_ka
    cust.contact = bs_customer.contact.blank? ? nil : bs_customer.contact.strip.to_ka
    cust.balance = bs_customer.balance
    cust.old_balance = bs_customer.old_balance
    cust.illegalline = bs_customer.illegalline == 1
    cust.except = bs_customer.except == 1
    cust.goodpayer = bs_customer.except == 1
    cust.payint = bs_customer.payint
    cust.cut = bs_customer.cut == 1
    cust.statuskey = bs_customer.statuskey
    cust.save
  end

  def self.sync_all!
    perstep = 1000
    total = Bs::Customer.count
    #0.upto(total/perstep + 1) do |i|
    t1 = Time.now
    0.upto(0) do |i|
      Bs::Customer.order('custkey').offset(perstep*i).limit(perstep).each do |cust|
        Bs::Mongo::Customer.sync!(cust.custkey)
      end
    end
    puts (Time.now - t1)
  end

  private

  def self.create_address(bs_address)
    Bs::Mongo::Address.new(
      premisekey: bs_address.premisekey,
      regionkey: bs_address.region.regionkey,
      regionname: bs_address.region.regionname.strip.to_ka,
      streetkey: bs_address.street.streetkey,
      streetname: bs_address.street.streetname.strip.to_ka,
      house: bs_address.house.blank? ? nil : bs_address.house.strip.to_ka,
      building: bs_address.building.blank? ? nil : bs_address.building.strip.to_ka,
      porch: bs_address.porch.blank? ? nil : bs_address.porch.strip.to_ka,
      flate: bs_address.flate.blank? ? nil : bs_address.flate.strip.to_ka,
      postindex: bs_address.postindex.blank? ? nil : bs_address.postindex.strip.to_ka,
      roomnumber: bs_address.roomnumber,
      read_seq: bs_address.read_seq
    )
  end

end

class Bs::Mongo::Address
  include Mongoid::Document
  field :premisekey, type: Integer
  field :regionkey,  type: Integer
  field :regionname, type: String
  field :streetkey,  type: Integer
  field :streetname, type: String
  field :house,    type: String
  field :building, type: String
  field :porch,    type: String
  field :flate,    type: String
  field :postindex,  type: String
  field :roomnumber, type: Integer
  field :read_seq,   type: Integer
end

class Bs::Mongo::CustomerCategory
  include Mongoid::Document
  field :custcatkey, type: Integer
  field :custcatname, type: String
end
