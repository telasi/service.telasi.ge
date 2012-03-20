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
