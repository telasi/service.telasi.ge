# -*- encoding : utf-8 -*-

module ApplicationsHelper

  def app_status_icon(app)
    case app.status
    when Application::STATUS_START
      'flag'
    when Application::STATUS_SENT
      'time'
    when Application::STATUS_CANCELED
      'remove-sign'
    when Application::STATUS_ACCEPTED
      'ok-sign'
    when Application::STATUS_CLOSED
      'lock'
    end
  end

  def app_status_name(app)
    case app.status
    when Application::STATUS_START
      'საწყისი'
    when Application::STATUS_SENT
      'გაგზავნილი'
    when Application::STATUS_CANCELED
      'გაუქმებული'
    when Application::STATUS_ACCEPTED
      'მიღებული'
    when Application::STATUS_CLOSED
      'დასრულებული'
    end
  end

end