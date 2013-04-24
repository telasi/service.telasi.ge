# -*- encoding : utf-8 -*-
require 'kramdown'

class Call::Doc
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String
  field :text,  type: String
  field :text_html, type: String
  field :file,  type: String
  field :order_by, type: Integer

  before_save :on_before_save

  private

  def on_before_save
    self.text_html = Kramdown::Document.new(self.text).to_html
  end

end
