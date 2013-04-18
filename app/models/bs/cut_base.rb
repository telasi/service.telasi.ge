# -*- encoding : utf-8 -*-
module Bs::CutBase
  OPER_CUT = 0
  OPER_RESTORE = 1

  MARK_START = 0
  MARK_COMPLETE = 1
  MARK_NOT_COMPLETE = 2

  module InstanceMethods

    def operation
      case self.oper_code
      when OPER_CUT then 'ჩაჭრა'
      when OPER_RESTORE then 'აღდგენა'
      end
    end

    def result
      oper = '?'
      if self.oper_code == OPER_RESTORE
        case self.mark_code
        when MARK_START then oper = 'მონიშნულია აღსადგენად'
        when MARK_COMPLETE then oper = 'აღდგენილია'
        when MARK_NOT_COMPLETE then oper = 'ვერ აღდგა'
        end
      else
        case self.mark_code
        when MARK_START then oper = 'მონიშნულია ჩასაჭრელად'
        when MARK_COMPLETE then oper = 'ჩაჭრილია'
        when MARK_NOT_COMPLETE then oper = 'ვერ ჩაიჭრა'
        end
      end
      "აბონენტი #{oper}"
    end

  end

  def self.included(base)
    base.primary_key = :cr_key
    base.belongs_to :customer, class_name: 'Bs::Customer', foreign_key: :custkey
    base.belongs_to :account, class_name: 'Bs::Account', foreign_key: :acckey
    base.send :include, InstanceMethods
  end

end
