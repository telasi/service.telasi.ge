class Sms_client_data
 include Mongoid::Document
 include Mongoid::Timestamps
  field :clientname, type: String 
  field :phone, type: Integer
  field :lang, type: String
  field :active, type: String, default: 'N'
  field :group, type: String
end