# -*- encoding : utf-8 -*-
class MagtiController < ApplicationController

  def index
    Magti.send_sms "595335514", "SMS migebulia"
    render layout: false
  end

end
