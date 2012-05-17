# -*- encoding : utf-8 -*-
class Document
  include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :documentable, polymorphic: true
  field :file, type: String
  field :comment, type: String
  mount_uploader :file, DocumentUploader
  validates_presence_of :file
  validates_presence_of :comment, message: 'ჩაწერეთ აღწერილობა'
end
