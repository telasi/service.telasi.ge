# -*- encoding : utf-8 -*-

require 'spec_helper'

feature 'მომხმარებლის ავტორიზაცია' do
  before(:all) do
    @user = Factory(:user, :password => 'secret')
  end
  scenario 'სწორი მონაცემებით' do
    visit login_url
    has_css?('form')
    find('legend').should have_content 'სისტემაში შესვლა'
    make_login(page, @user.email, 'secret')
    current_url.should == home_url
    find('#user-info').should have_content @user.full_name
  end
  scenario 'არასწორი მონაცემებით' do
    make_login(page, @user.email, 'wrong_password')
    current_url.should == login_url
    find('#error-explanation').should have_content 'არასწორი მომხმარებელი ან პაროლი'
  end
end

feature 'მომხმარებლის მონაცემების შეცვლა' do
  before(:all) do
    @user = Factory(:user, :password => 'secret')
  end
  scenario 'მომხმარებლის მონაცემების შეცვლა' do
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
end
