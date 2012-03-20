# -*- encoding : utf-8 -*-

class UserMailer < ActionMailer::Base
  default :from => "Telasi.ge <sys@telasi.ge>"

  def email_confirmation(user)
    @user = user
    @url = "#{confirm_url(:host => Telasi::HOST)}?hash=#{@user.email_confirm_hash}&id=#{@user.id}"
    mail(:to => "#{@user.full_name} <#{@user.email}>", :subject => 'რეგისტრაციის დასრულება')
  end

end
