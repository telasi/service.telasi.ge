# -*- encoding : utf-8 -*-
module GisHelper

  def gis_log_icon(log)
    image_tag log.enabled? ? '/assets/fff/accept.png' : '/assets/fff/cancel.png'
  end

  def gislog_class(log)
    case log.sms_status
    when Ext::Gis::Log::STATUS_FOR_SENT
      'warning'
    when Ext::Gis::Log::STATUS_SENT_CANCELED
      'error'
    when Ext::Gis::Log::STATUS_SENT
      'success'
    end
  end

end
