# -*- encoding : utf-8 -*-
module GisHelper

  def gislog_class(log)
    case log.sms_status
    when Ext::GisLog::STATUS_FOR_SENT
      'warning'
    when Ext::GisLog::STATUS_SENT_CANCELED
      'error'
    when Ext::GisLog::STATUS_SENT
      'success'
    end
  end

end
