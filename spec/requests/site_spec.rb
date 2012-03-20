# -*- encoding : utf-8 -*-

require 'spec_helper'

def test_illegal_login(email, pwd)
  make_login(page, email, pwd)
  current_url.should == login_url
  find('#error-explanation').should have_content 'არასწორი მომხმარებელი ან პაროლი'
end

def test_legal_login(email, pwd)
  make_login(page, email, pwd)
  current_url.should == home_url
  user = User.where(:email => email).first
  find('#user-info').should have_content user.full_name
end

feature 'მომხმარებლის ავტორიზაცია' do
  before(:all) do
    @user = Factory(:user, :password => 'secret')
  end
  scenario 'სწორი მონაცემებით' do
    visit login_url
    has_css?('form')
    find('legend').should have_content 'სისტემაში შესვლა'
    test_legal_login(@user.email, 'secret')
  end
  scenario 'არასწორი მონაცემებით' do
    test_illegal_login(@user.email, 'wrong_password')
  end
end

feature 'მომხმარებლის მონაცემების შეცვლა' do
  before(:all) do
    @user = Factory(:user, :password => 'secret')
  end
  scenario 'ძირითადი მონაცემების შეცვლა' do
    make_login(page, @user.email, 'secret')
    visit account_url
    within('#account-form') do
      fill_in 'user_first_name', :with => 'დიმიტრი'
      fill_in 'user_last_name', :with => 'ყურაშვილი'
      fill_in 'user_mobile', :with => '(595)335-514'
      click_button 'შენახვა'
    end
    @user = User.find(@user.id)
    @user.full_name.should == 'დიმიტრი ყურაშვილი'
    @user.mobile.should == '595335514'
  end
  scenario 'პაროლის გამოვლა' do
    make_login(page, @user.email, 'secret')
    visit change_password_url
    within('#password-form') do
      fill_in 'user_password', :with => 'new_password'
      fill_in 'user_password_confirmation', :with => 'new_password'
      click_button 'პაროლის შეცვლა'
    end
    test_illegal_login(@user.email, 'secret')
    test_legal_login(@user.email, 'new_password')
  end
end
