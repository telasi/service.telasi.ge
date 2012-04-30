# -*- encoding : utf-8 -*-
def login(email, password, opts = {})
  user = User.where(:email => email).first
  user = create(:user, :email => email, :password => password) if opts[:create] and user.nil?
  visit login_path
  fill_in 'ელ.ფოსტა', :with => email
  fill_in 'პაროლი', :with => password
  click_button 'შესვლა'
  user
end

