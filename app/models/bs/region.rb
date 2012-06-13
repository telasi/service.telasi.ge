# -*- encoding : utf-8 -*-
class Bs::Region < ActiveRecord::Base
  self.table_name  = 'region'
  self.primary_key = :regionkey

  def address
    a = self.location.split('T')[0]
    a && a.to_ka.gsub('N', '№').gsub(',', ', ').gsub('.', '. ')
  end

  def phone
    p = self.location.split('T')[1]
    p && p.to_ka.gsub(',', ', ')
  end

end
