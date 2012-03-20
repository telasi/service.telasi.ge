# -*- encoding : utf-8 -*-

class UserMailer < ActionMailer::Base
  default :from => "Telasi.ge <sys@telasi.ge>"

  def email_confirmation(user)
    @user = user
    @url = "#{register_url(:host => Telasi::HOST)}?c=#{@user.email_confirm_hash}&email=#{@user.email}"
    mail(:to => "#{@user.full_name} <#{@user.email}>", :subject => 'რეგისტრაციის დასრულება')
  end

end
