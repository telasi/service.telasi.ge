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
    if log.section?
      image_tag('fff/lightning.png')
    elsif log.fider?
      image_tag('fff/disconnect.png')
    elsif log.transformator?
      image_tag('fff/lightbulb.png')
    end
  end

  def gislog_type(log)
    if log.section?
      'სექცია'
    elsif log.fider?
      'ფიდერი'
    elsif log.transformator?
      'ტრანს.'
    end
  end

end
