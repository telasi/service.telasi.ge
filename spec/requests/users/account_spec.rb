# -*- encoding : utf-8 -*-
require 'spec_helper'

feature 'მომხმრებლის შეცვლა:' do
	before(:all) do
		@user = login('dimitri@c12.ge', 'secret', :create => true)
		visit account_url
		fill_in 'სახელი', :with => 'Sakura'
		fill_in 'გვარი',  :with => 'Hinobarachi'
		fill_in 'მობილური', :with => '(599)422451'
		click_on 'შენახვა'
	end
	context 'ანალიზი' do
		subject { User.find(@user.id) }
		its(:first_name) { should == 'Sakura' }
		its(:last_name) { should == 'Hinobarachi'}
		its(:mobile) { should == '599422451' }
	end
end
