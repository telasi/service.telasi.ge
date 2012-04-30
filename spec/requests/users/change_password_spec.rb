# -*- encoding : utf-8 -*-
require 'spec_helper'

feature 'პაროლის შეცვლა მომხმარებელზე:' do
	scenario 'მომხმარებელი ცვლის პაროლს', :js => true do
		login('dimitri@c12.ge', 'secret', :create => true)
		visit change_password_path
		fill_in 'ახალი პაროლი', :with => 'new_password'
		fill_in 'პაროლის დადასტურება', :with => 'new_password'
		click_on 'პაროლის შეცვლა'
	end
  context 'ძველი პაროლით ავტორიზაცია' do
    subject { User.authenticate('dimitri@c12.ge', 'secret') }
    it { should be_nil }
  end
  context 'ახალი პაროლით ავტორიზაცია' do
    subject { User.authenticate('dimitri@c12.ge', 'new_password') }
    it { should_not be_nil }
  end
end

