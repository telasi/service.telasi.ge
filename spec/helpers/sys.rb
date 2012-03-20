# -*- encoding : utf-8 -*-

def make_login(session, email, pwd)
  session.visit login_url
  session.within('#login-form') do
    session.fill_in 'email', :with => email
    session.fill_in 'password', :with => pwd
    session.click_button 'შესვლა'
  end
end
