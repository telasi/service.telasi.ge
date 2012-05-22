# -*- encoding : utf-8 -*-
module LogHelper
  def log_image(log)
    case log.type
    when Log::CREATE
      icon('plus')
    when Log::SHARE
      icon('share')
    end
  end
end
