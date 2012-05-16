# -*- encoding : utf-8 -*-
class Document
  include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :documentable, polymorphic: true
  field :file, type: String
  mount_uploader :file, DocumentUploader
end