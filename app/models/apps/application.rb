# -*- encoding : utf-8 -*-

# ეს არის აბონენტის განაცხადის კლასი.
class Apps::Application
  include Mongoid::Document
  include Mongoid::Timestamps

  # ახალი აბონენტის მიერთების განცხადება.
  TYPE_NEW_CUSTOMER = 'new_customer'

  field :type,   type: String
  field :number, type: Integer
  belongs_to :owner, :class_name => 'User'
  embeds_one :applicant, :class_name => 'Apps::Applicant'
  embeds_one :new_customer_application, :class_name => 'Apps::NewCustomerApplication'
  has_many :documents, as: :documentable

  def self.by_user(user)
    where(owner_id: user.id)
  end

end