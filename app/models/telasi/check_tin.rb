# -*- encoding : utf-8 -*-
require 'rs'

# ეს მოდული ამატებს საიდენტიფიკაციო კოდის შემოწმების ფუნქციას.
module Telasi::CheckTin
  def check_tin
    unless self.tin.blank?
      if not RS.is_valid_personal_tin(self.tin) and not RS.is_valid_corporate_tin(self.tin)
        errors.add(:tin, 'უნდა იყოს 9 ან 11 ციფრიანი კოდი')
      elsif self.tin_changed? and Telasi::TIN_CHECK
        self.name = RS.get_name_from_tin('tin' => self.tin)
        errors.add(:tin, 'არასწორი საიდენტიფიკაციო კოდი') if self.name.nil?
      end
    end
  end

  def self.included(base)
    base.validate :check_tin
  end
end
