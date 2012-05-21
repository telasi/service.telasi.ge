# -*- encoding : utf-8 -*-

# ეს არის აბონენტის განაცხადის კლასი.
class Apps::Application
  include Mongoid::Document
  include Mongoid::Timestamps

  # ახალი აბონენტის მიერთების განცხადება.
  TYPE_NEW_CUSTOMER = 'new_customer'

  field :type,    type: String
  field :number,  type: Integer
  field :private, type: Boolean, default: true
  belongs_to :owner, :class_name => 'User'
  embeds_one :applicant, :class_name => 'Apps::Applicant'
  embeds_one :new_customer_application, :class_name => 'Apps::NewCustomerApplication'
  embeds_many :logs, as: :loggable, cascade_callbacks: true
  has_many :documents, as: :documentable

  def self.by_user(user)
    where(owner_id: user.id)
  end

  def add_log(user, text, type=Log::COMMON)
    self.logs << Log.new(user: user, text:text, type: type)
  end
  
end
