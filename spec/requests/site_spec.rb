# -*- encoding : utf-8 -*-

require 'spec_helper'

feature "ახალი მომხმარებლის რეგისტრაცია" do
  scenario "მონაცემების გაგზავნა" do
    visit register_url
    has_css?('form')
    find('form legend').should have_content 'ახალი მომხმარებლის რეგისტრაცია'
    within('#register-form') do
      fill_in 'user_email', :with => 'dimitri@c12.ge'
      fill_in 'user_password', :with => 'secret'
      fill_in 'user_password_confirmation', :with => 'secret'
      fill_in 'user_mobile', :with => '595335514'
      fill_in 'user_first_name', :with => 'Dimitri'
      fill_in 'user_last_name', :with => 'Kurashvili'
      click_button 'რეგისტრაცია'
    end
    user = User.where(:email => 'dimitri@c12.ge').first
    user.should_not be_nil
    current_url.should == register_url(:status => :ok)
    find('h3').should have_content 'რეგისტრაცია წარმატებულია'
  end
end

feature "მომხმარებლის ავტორიზაცია" do
  background do
    @user = Factory(:user, :password => 'secret')
  end
  scenario "მონაცემების შევსება და შესვლა" do
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
end
