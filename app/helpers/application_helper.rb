# -*- encoding : utf-8 -*-
require 'kramdown'

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
    user.has_role?(role)
  end

  def kramdown(text)
    return Kramdown::Document.new(text).to_html.html_safe
  end

  def html_spaces(cnt = 3)
    text = ''
    cnt.times { text += '&nbsp;' }
    text.html_safe
  end

end
