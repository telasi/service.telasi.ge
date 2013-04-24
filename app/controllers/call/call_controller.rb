# -*- encoding : utf-8 -*-
class Call::CallController < ApplicationController

  before_filter :validate_login, :validate_call_privileges

  protected

  def validate_call_privileges
    unless current_user.call_center
      redirect_to login_url, alert: 'თქვენ არ გაქვს ქოლ-ცენტრის პროგრამით სარგებლობის უფლება.'
    end
  end

end
