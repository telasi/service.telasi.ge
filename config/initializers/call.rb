# -*- encoding : utf-8 -*-

module Call

  # ეს ინტერვალი გამოიყენება დავალებების დასასინქონებლად.
  SYNC = 100.hours

  # ამ ინტერვალში შეიძლება მაქსიმუმ 1 დავალების გაშვება.
  REPEAT = 30.minutes

  # რამდენი დღე უნდა დასცალდეს აბონენტს ვალის გადახდა?
  DAYS_BEFORE_CUT = 7

  def self.call_center_sms_send_time
    hour = Time.now.localtime.hour
    wday = Time.now.localtime.wday
    if wday == 6 or wday == 7
      (hour >= 10 && hour <= 21) # Weekends 10:00:00 - 21:59::59
    else
      (hour >= 18 && hour <= 21) # Weekdays 18:00:00 - 21:59::59
    end
  end

end
