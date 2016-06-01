# -*- encoding : utf-8 -*-
module Call
  SYNC = 100.hours
  REPEAT = 30.minutes
  WEEKDAYS = [ Date.new(2013,5,9) ]

  def self.is_weekend(time)
    time.saturday? or time.sunday? or WEEKDAYS.include?(time.to_date)
  end

  def self.call_center_sms_send_time
    hour = Time.now.localtime.hour
    #wday = Time.now.localtime.wday
    if is_weekend(Time.now.localtime)
      (hour >= 10 && hour <= 19) # Weekends 10:00:00 - 19:59::59
    else
      (hour >= 18 && hour <= 19) # Weekdays 18:00:00 - 19:59::59
    end
  end
end
