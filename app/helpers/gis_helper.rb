# -*- encoding : utf-8 -*-
module GisHelper

  def gislog_icon(log)
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

  def gislog_typeicon(log)
    if log.transformator?
      image_tag('fff/lightbulb.png')
      # fff/lightning.png
      # fff/disconnect.png
    end
  end

  def gislog_type(log)
    if log.transformator?
      'ტრანს.'
    end
  end

end
