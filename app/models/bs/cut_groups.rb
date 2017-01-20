# -*- encoding : utf-8 -*-
class Bs::CutGroups < ActiveRecord::Base

  STATUS_DEFAULT  = 0
  STATUS_SENT     = 1
  STATUS_RECEIVED = 2
  
  self.table_name  = 'bs.cut_groups' 
  self.set_integer_columns :inspector, :oper_code, :status, :download_count

  has_one :operator, class_name: 'Bs::Person', primary_key: :operator, foreign_key: :perskey
  has_one :region, class_name: 'Bs::Region', primary_key: :regionkey, foreign_key: :regionkey
  has_many :items, class_name: 'Bs::CutHistory', foreign_key: :cutgroup
end
