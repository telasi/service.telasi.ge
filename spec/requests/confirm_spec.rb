# -*- encoding : utf-8 -*-

require 'spec_helper'

def make_login(email, pwd)
  within('#login-form') do
    fill_in 'email', :with => email
    fill_in 'password', :with => 'secret'
    click_button 'შესვლა'
  end
end

feature 'მომხმარებელის ავტორიზაცია და აქტივაცია' do
  before(:all) do
    @admin = Factory(:user, :email => 'dimitri@c12.ge', :password => 'secret')
    @user  = Factory(:user, :email => 'dimakura@gmail.com', :password => 'secret')
  end
  scenario 'პიველი მომხმარებელი შედის სისტემაში' do
    visit login_url
    make_login(@admin.email, 'secret')
    current_url.should == home_url
    find('#user-info').should have_content @admin.full_name
  end
  scenario 'მეორე მომხმარებელი ვერ შედის სისტემაში (ის არაა აქტიური)' do
    visit login_url
    make_login(@user.email, 'secret')
    current_url.should == login_url
    find('#error-explanation').should have_content 'ეს ანგარიში დაუდასტურებელია'
  end
  scenario 'მეორე მომხმარებელი ააქტიურებს თავის ანგარიშს' do
    visit confirm_url(:hash => @user.email_confirm_hash, :id => @user.id)
    find('#success').should have_content 'თქვენი ელ.ფოსტის დადასტურება წარმატებულია'
    @user = User.find(@user.id)
    @user.email_confirm_hash.should be_nil
    @user.email_confirmed.should == true
  end
  scenario 'მეორე მომხმარებელს უკვე შეუძლია შესვლა თავის ანგარიშში' do
    visit login_url
    make_login(@user.email, 'secret')
    current_url.should == home_url
    find('#user-info').should have_content @user.full_name
  end
end
