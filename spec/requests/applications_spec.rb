# -*- encoding : utf-8 -*-

require 'spec_helper'

feature 'განცხადებები' do
  before(:all) do
    @user = Factory(:user, :password => 'secret')
  end
  scenario 'საწყის გვერდზე შესვლა' do
    make_login(page, @user.email, 'secret')
    visit home_url
    find('.page-header').should have_content 'განცხადებები'
  end
  scenario 'ახალი განცხადების გვერდი' do
    make_login(page, @user.email, 'secret')
    visit new_application_url
    within('#application-form') do
      # XXX
    end
  end
end
