class Sms_log_tbl
 include Mongoid::Document
 include Mongoid::Timestamps
  field :phone, type: Integer
  field :group, type: String
  field :smsmodeule, type: String
  field :lang, type: String
end