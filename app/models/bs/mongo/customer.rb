# -*- encoding : utf-8 -*-
class Bs::Mongo::Customer
  include Mongoid::Document
  include Mongoid::Timestamps
  store_in collection: 'bs_customer'
  
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
  field :illegalline, type: Boolean
  field :except, type: Boolean
  field :goodpayer, type: Boolean
  field :payint, type: Integer
  field :cut, type: Boolean
  field :status, type: Integer

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
