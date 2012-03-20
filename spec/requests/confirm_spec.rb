# -*- encoding : utf-8 -*-

require 'spec_helper'

feature 'მომხმარებელის ავტორიზაცია და აქტივაცია' do
  before(:all) do
    @admin = Factory(:user, :email => 'dimitri@c12.ge', :password => 'secret')
    @user  = Factory(:user, :email => 'dimakura@gmail.com', :password => 'secret')
  end
  scenario 'პიველი მომხმარებელი შედის სისტემაში' do
    make_login(page, @admin.email, 'secret')
    current_url.should == home_url
    find('#user-info').should have_content @admin.full_name
  end
  scenario 'მეორე მომხმარებელი ვერ შედის სისტემაში (ის არაა აქტიური)' do
    make_login(page, @user.email, 'secret')
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
    make_login(page, @user.email, 'secret')
    current_url.should == home_url
    find('#user-info').should have_content @user.full_name
  end
end
