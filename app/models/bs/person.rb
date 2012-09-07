# -*- encoding : utf-8 -*-
class Bs::Person < ActiveRecord::Base
  self.table_name  = 'bs.person'
  self.primary_key = :perskey
end
