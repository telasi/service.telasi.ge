# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'cgi'

def register(params = {})
  visit register_url
  fill_in('ელ. ფოსტა', :with => (params[:email] || 'dimitri@c12.ge'))
  fill_in('პაროლი', :with => (params[:password] || 'secret'))
  fill_in('დაადასტურეთ პაროლი', :with => (params[:password] || 'secret'))
  fill_in('სახელი', :with => (params[:first_name] || 'დიმიტრი'))
  fill_in('გვარი', :with => (params[:last_name] || 'ყურაშვილი'))
  fill_in('მობილური', :with => (params[:mobile] || '(595)335514'))
  click_button('რეგისტრაცია')
end

feature 'მომხმარებლის რეგისტრაცია:' do
  context 'პირველი მომხმარებელი:' do
    before(:all) do
      register(:email => 'dimitri@c12.ge')
    end
    context 'მომხმარებელთა საერთო რიცხვი' do
      subject { User.count }
      it { should == 1 }
    end
    context 'მომხმარებლის ანალიზი' do
      subject { User.last }
      its(:email) { should == 'dimitri@c12.ge' }
      its(:first_name) { should == 'დიმიტრი' }
      its(:last_name) { should == 'ყურაშვილი' }
      its(:mobile) { should == '595335514' }
      its(:email_confirmed) { should == true }
    end
    context 'წერილის ანალიზი' do
      subject { ActionMailer::Base.deliveries.last }
      it { should be_nil }
    end
  end
  context 'მეორე მომხმარებელი:' do
    before(:all) do
      register(:email => 'dimakura@gmail.com')
    end
    context 'მომხმარებელთა საერთო რიცხვი' do
      subject { User.count }
      it { should == 2 }
    end
    context 'მომხმარებლის ანალიზი' do
      subject { User.last }
      its(:email) { should == 'dimakura@gmail.com' }
      its(:email_confirmed) { should == false }
    end
    context 'წერილის ანალიზი' do
      subject { ActionMailer::Base.deliveries.last }
      it { should_not be_nil }
      its(:subject) { should == 'რეგისტრაციის დასრულება' }
      its(:body) { should be_include(CGI.escapeHTML(confirm_url(:host => Telasi::HOST, :id => User.last.id, :c => User.last.email_confirm_hash))) }
    end
  end
  context 'მეორე მომხმარებლის დადასტურება' do
    # XXX
  end
end
