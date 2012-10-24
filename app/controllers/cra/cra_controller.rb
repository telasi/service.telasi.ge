# -*- encoding : utf-8 -*-
class Cra::CraController < ApplicationController
  before_filter :cra_validation

  private

  def cra_validation
    user = current_user
    if user.blank?
      session[:return_url] = request.url
      redirect_to login_url, notice: 'გაიარეთ ავტორიზაცია.'
    elsif !can_view?(user)
      redirect_to login_url, notice: 'არ გაქვთ შესვლის უფლება.'
    end
  end

  def can_view?(user)
    if user.has_role?([:cra])
      true
    else
      false
    end
  end

  public

  def index
    @title = 'საჯარო რეესტრის მონაცემების ძებნა'
  end

end
