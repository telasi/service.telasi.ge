# -*- encoding : utf-8 -*-

# განმცხადებელზე ინფორმაცია.
class Apps::Applicant
	include Mongoid::Document
	include Telasi::CheckTin
	field :tin,     type: String
	field :name,    type: String
	field :mobile,  type: String
	field :email,   type: String
	field :address, type: String
	embedded_in :application, :class_name => 'Apps::Application'
	validates_presence_of :tin, :message => 'ჩაწერეთ საიდენტიფიკაციო კოდი'
	validates_presence_of :name
	validates_presence_of :mobile, :message => 'ჩაწერეთ მობილური'
	validates_presence_of :email, :message => 'ჩაწერეთ ელ.ფოსტა'
	validates_presence_of :address, :message => 'ჩაწერეთ მისამართი'
end
