# -*- encoding : utf-8 -*-

require 'spec_helper'

feature "ახალი მომხმარებლის რეგისტრაცია" do
  scenario "ფორმის გაგზავნა" do
    visit register_url
    within("#register-form") do
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
  end
end
