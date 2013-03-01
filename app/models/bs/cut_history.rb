# -*- encoding : utf-8 -*-
class Bs::CutHistory < ActiveRecord::Base
  self.table_name  = 'dimitri.ruby_cut_history'
  self.primary_key = :cr_key
  set_integer_columns :oper_code, :mark_code
  belongs_to :customer,  class_name: 'Bs::Customer', foreign_key: :custkey
  belongs_to :account,   class_name: 'Bs::Account',  foreign_key: :acckey

  def restore?
    self.oper_code == 1
  end

  def complete?
    self.mark_code == 1
  end

  def operation
    self.restore? ? 'აღდგენა' : 'ჩაჭრა'
  end

  def result
    if self.restore?
      self.complete? ? 'აბონენტი აღდგენილია' : 'აბონენტი ვერ აღდგა'
    else
      self.complete? ? 'აბონენტი ჩაჭრილია' : 'აბონენტი არ ჩაჭრილა'
    end
  end

end
