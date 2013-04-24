# -*- encoding : utf-8 -*-
class Call::Doc
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String
  field :text,  type: String
  field :file,  type: String
  field :order_by, type: Integer

end
