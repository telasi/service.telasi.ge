# -*- encoding : utf-8 -*-
class Bs::CutHistory < ActiveRecord::Base
  self.table_name  = 'dimitri.ruby_cut_history'
  self.primary_key = :cr_key
  belongs_to :customer,  class_name: 'Bs::Customer', foreign_key: :custkey
  belongs_to :account,   class_name: 'Bs::Account',  foreign_key: :acckey

  def operation
    if oper_code
      'აღდგენა'
    else
      'ჩაჭრა'
    end
  end
end
