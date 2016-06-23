# -*- encoding : utf-8 -*-
#require 'kramdown'

class Call::Document
  include Mongoid::Document
  field :name, type: String
  field :document, type: String
  field :document_html, type: String

  mount_uploader :calldocument, CalldocUploader

  before_save :on_before_save

  private

  def on_before_save
    #self.document_html = Kramdown::Document.new(self.document).to_html
    self.document_html="<pre id=preformat1> " + self.document.to_s + "</pre>"
  end


end
