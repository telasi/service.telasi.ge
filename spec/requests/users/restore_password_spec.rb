# -*- encoding : utf-8 -*-
require 'spec_helper'

feature 'მომხმარებლის პაროლის აღდგენა' do
	before(:all) do
		@user = create(:user, :email => 'dimitri@c12.ge')
	end
	context 'პაროლის აღდგენის მოთხოვნა' do
		scenario :js => true do
			visit restore_password_path
			fill_in 'email', :with => 'dimitri@c12.ge'
			click_on 'პაროლის აღდგენა'
		end
	end
	context 'წერილის გაგზავნა' do
		subject { ActionMailer::Base.deliveries.last }
		it { should_not be_nil }
		its(:subject) { should == 'პაროლის აღდგენა' }
		its(:body) { should be_include(CGI.escapeHTML(new_password_url(:host => Telasi::HOST, :id => User.last.id, :h => User.last.new_password_hash))) }
	end
	context 'ვიზიტი პაროლის აღდგენის გვერდის ვიზიტი' do
		scenario :js => true do
			@use = @user.reload
			visit new_password_path(:h => @user.new_password_hash, :id =>@user.id)
			fill_in 'ახალი პაროლი', :with => 'new_password'
			fill_in 'პაროლის დადასტურება', :with => 'new_password'
			click_on 'პაროლის შეცვლა'
		end
	end
	context 'მომხმარებლის ავტორიზაცია: ძველი პაროლი' do
		subject { User.authenticate('dimitri@c12.ge', 'secret') }
		it { should be_nil }
	end
	context 'მომხმარებლის ავტორიზაცია: ახალი პაროლი' do
		subject { User.authenticate('dimitri@c12.ge', 'new_password') }
		it { should_not be_nil }
		it { should == @user }
	end
end
