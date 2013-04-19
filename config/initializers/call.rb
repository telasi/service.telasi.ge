# -*- encoding : utf-8 -*-

module Call

  # ეს ინტერვალი გამოიყენება დავალებების დასასინქონებლად.
  SYNC = 100.hours

  # ამ ინტერვალში შეიძლება მაქსიმუმ 1 დავალების გაშვება.
  REPEAT = 30.minutes

  def self.call_center_sms_send_time
    hour = Time.now.localtime.hour
    (hour >= 18 && hour <= 21) # 18:00:00 - 21:59::59
  end

end
