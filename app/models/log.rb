# -*- encoding : utf-8 -*-
class Log
  COMMON = 'common'
  CREATE = 'create'
  SHARE  = 'share'
  OK = 'ok'
  BAN = 'ban'
  COMPLETE = 'complete'
  ERROR = 'error'

  include Mongoid::Document
  include Mongoid::Timestamps
  field :type, type: String, default: COMMON
  field :text, type: String

  validates_presence_of :text, message: 'ჩაწერეთ შენიშვნა'

  belongs_to  :user
  embedded_in :loggable, polymorphic: true

  index :logabble_id
end
