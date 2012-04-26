# -*- encoding : utf-8 -*-
module SupportHelper
  def telasi_ge
    link_to 'სს თელასი', 'http://www.telasi.ge'
  end

  def support_email
    mail_to 'support@telasi.ge'
  end

  def support_phone
    '2 779-886'
  end
end