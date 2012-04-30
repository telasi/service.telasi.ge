# -*- encoding : utf-8 -*-
require 'spec_helper'

feature 'მომხმარებლის პაროლის აღდგენა' do
	before(:all) do
		@user = create(:user, :email => 'dimitri@c12.ge')
	end
	context 'პაროლის აღდგენის მოთხოვნა' do
		# XXX
	end
end
