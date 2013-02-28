# -*- encoding : utf-8 -*-
class Bs::Note < ActiveRecord::Base
  self.table_name  = 'bs.notes'
  self.primary_key = :notekey

  def to_s
    self.note.to_ka if self.note
  end
end