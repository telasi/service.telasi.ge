# -*- encoding : utf-8 -*-
class Gnerc::Queue < ActiveRecord::Base
  self.table_name  = 'semek.queue'
  self.primary_key = 'id'

  SERVICE = 'Cutter'
end
