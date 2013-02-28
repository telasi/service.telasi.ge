# -*- encoding : utf-8 -*-
class Bs::Person < ActiveRecord::Base
  self.table_name  = 'bs.person'
  self.primary_key = :perskey

  def to_s
    self.persname.to_ka
  end
end
