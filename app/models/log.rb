# -*- encoding : utf-8 -*-
class Log
  include Mongoid::Document
  include Mongoid::Timestamps
  field :type, type: String
  field :text, type: String
  belongs_to  :user
  embedded_in :loggable, polymorphic: true
  index :logabble_id
end
