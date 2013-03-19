class Call::Sms
  include Mongoid::Document
  include Mongoid::Timestamps

  field :mobile, type: String
  field :text,   type: String
  belongs_to :user
  belongs_to :task, class_name: 'Call::Task'

end
