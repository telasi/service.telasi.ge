# -*- encoding : utf-8 -*-
class Bs::CutHistory < ActiveRecord::Base
  include Bs::CutBase
  self.table_name  = 'dimitri.ruby_cut_history'
end
