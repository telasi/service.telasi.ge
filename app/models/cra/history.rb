# -*- encoding : utf-8 -*-
class Cra::History
  include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :user
  field :parameters, type: Hash
  field :result, type: Hash
end
