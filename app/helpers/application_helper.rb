# -*- encoding : utf-8 -*-
module ApplicationHelper
  def current_user
    controller.current_user
  end

  def role_content(*role, &block)
    user = current_user
    capture &block if user and with_role?(user, role)
  end

  # აქვს თუ არა მომხმარებელს არგუმენტში მოცემული როლი.
  # როლი შეიძლება გადმოსცეთ მასივის ან ცალკეული სიმბოლოს სახით.
  def with_role?(user, role)
    if role.is_a? Array
      role.each { |r| return true if with_role?(user, r) }
      false
    elsif role.to_sym == :all
      true
    else
      user.send role.to_sym if user.respond_to?(role.to_sym)
    end
  end

end
