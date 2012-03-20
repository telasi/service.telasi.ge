# -*- encoding : utf-8 -*-

require 'spec_helper'

def make_register(email, pwd = 'secret')
  visit register_url
  has_css?('form')
  find('form legend').should have_content 'ახალი მომხმარებლის რეგისტრაცია'
  within('#register-form') do
    fill_in 'user_email', :with => email
    fill_in 'user_password', :with => pwd
    fill_in 'user_password_confirmation', :with => pwd
    fill_in 'user_mobile', :with => '595335514'
    fill_in 'user_first_name', :with => 'Dimitri'
    fill_in 'user_last_name', :with => 'Kurashvili'
    click_button 'რეგისტრაცია'
  end
  user = User.where(:email => email).first
  user.should_not be_nil
  current_url.should == register_url(:status => :ok)
  find('h3').should have_content 'რეგისტრაცია წარმატებულია'
end

feature 'რეგისტრაცია:' do
  scenario 'პირველი მომხმარებლის რეგისტრაცია' do
    make_register('dimitri@c12.ge', 'secret')
    email = ActionMailer::Base.deliveries.last
    email.should be_nil
  end
  scenario 'მეორე მომხმარებლის რეგისტრაცია' do
    make_register('dimakura@gmail.com', 'secret')
    email = ActionMailer::Base.deliveries.last
    email.should_not be_nil
    email.to.should == ['dimakura@gmail.com']
    email.subject.should == 'რეგისტრაციის დასრულება'
  end
end

feature 'მომხმარებლის ავტორიზაცია' do
  before(:all) do
    @user = Factory(:user, :password => 'secret')
  end
  scenario 'სწორი მონაცემებით' do
    visit login_url
    has_css?('form')
    find('legend').should have_content 'სისტემაში შესვლა'
    within('#login-form') do
      fill_in 'email', :with => @user.email
      fill_in 'password', :with => 'secret'
      click_button 'შესვლა'
    end
    current_url.should == home_url
    find('#user-info').should have_content @user.full_name
  end
  scenario 'არასწორი მონაცემებით' do
    visit login_url
    within('#login-form') do
      fill_in 'email', :with => @user.email
      fill_in 'password', :with => 'wrong_password'
      click_button 'შესვლა'
    end
    current_url.should == login_url
    find('#error-explanation').should have_content 'არასწორი მომხმარებელი ან პაროლი'
  end
end
