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
end

