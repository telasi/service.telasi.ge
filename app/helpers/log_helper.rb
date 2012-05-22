# -*- encoding : utf-8 -*-
module LogHelper
  def log_image(log)
    case log.type
    when Log::CREATE
      icon('plus-sign')
    when Log::SHARE
      icon('share')
    when Log::OK
      icon('ok-sign')
    when Log::BAN
      icon('ban-circle')
    end
  end
end
