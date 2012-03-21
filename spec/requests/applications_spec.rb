# -*- encoding : utf-8 -*-

require 'spec_helper'

feature 'ტარიფები' do
  scenario 'html ფორმატი' do
    visit tariffs_url
    find('.page-header h2').should have_content 'მომსახურების ტარიფები'
    page.should have_css('table tbody tr', :count=>18)
  end
  scenario 'json ფორმატი' do
    visit tariffs_url(:format => :json)
    tariffs = JSON.parse(page.source)
    tariffs.length.should == 18
  end
end

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
    # TODO: complete form
#    within('#application-form') do
#      # XXX
#    end
  end
end
