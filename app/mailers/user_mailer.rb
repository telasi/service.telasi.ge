# -*- encoding : utf-8 -*-

class UserMailer < ActionMailer::Base
  default :from => "Telasi.ge <sys@telasi.ge>"

  # მომხმარებელზე დადასტურების კოდის გაგზავნა.
  #
  # დადასტურების მისამართის ფორმატია:
  #
  # <code>http://service.telasi.ge/confirm?c=confirm_code&id=user_id</code>
  #
  # სადაც, <code>confirm_code</code> არის მომხმარებლის დადასტურების კოდი,
  # ხოლო <code>user_id</code> არის მომხმარებლის საიდენტიფიკაციო ნომერი.
  def email_confirmation(user)
    @user = user
    @url = confirm_url(:host => Telasi::HOST, :c => @user.email_confirm_hash, :id => @user.id)
    mail(:to => "#{@user.full_name} <#{@user.email}>", :subject => 'რეგისტრაციის დასრულება')
  end

end
