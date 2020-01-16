# -*- encoding : utf-8 -*-
class Gnerc::QueueTest < ActiveRecord::Base
  self.table_name  = 'temo.queue'
  self.primary_key = 'id'

  SERVICE = 'Cutter'
end
