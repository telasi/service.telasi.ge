# -*- encoding : utf-8 -*-

# ეს არის აბონენტის განაცხადის კლასი.
class Application
  include Mongoid::Document
  include Mongoid::Timestamps

  # ახალი აბონენტის მიერთების განცხადება.
  TYPE_NEW_CUSTOMER = 'new_customer'

  field :type, type: String
	belongs_to :owner, :class_name => 'User'
	embeds_one :applicant
	embeds_one :new_customer_application
end

# განმცხადებელზე ინფორმაცია.
class Applicant
	include Mongoid::Document
	field :tin,     type: String
	field :name,    type: String
	field :mobile,  type: String
	field :email,   type: String
	field :address, type: String
	embedded_in :application
	validates_presence_of :tin, :message => 'ჩაწერეთ საიდენტიფიკაციო კოდი'
	validates_presence_of :name
	validates_presence_of :mobile, :message => 'ჩაწერეთ მობილური'
	validates_presence_of :email, :message => 'ჩაწერეთ ელ.ფოსტა'
	validates_presence_of :address, :message => 'ჩაწერეთ მისამართი'
end

# ახალი აბონენტის მიერთების განაცხადი.
class NewCustomerApplication
	include Mongoid::Document

	embedded_in :application
end

