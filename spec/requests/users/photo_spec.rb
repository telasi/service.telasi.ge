# -*- encoding : utf-8 -*-
require 'spec_helper'

feature 'მომხმარებლის გამოსახულების შეცვლა' do
  before(:all) do
    login('dimitri@c12.ge', 'secret', :create => true)
  end
  context 'გამოსახულების შეცვლამდე' do
    subject { User.first }
    its(:photo) { should_not be_file }
  end
  context 'გამოსახულების შეცვლა' do
    before(:all) do
      login('dimitri@c12.ge', 'secret')
      visit user_photo_path
      attach_file 'user_photo', File.join(Rails.root, 'spec/assets/images/user_photo.jpg')
      click_button 'გამოსახულების შეცვლა'
    end
    subject { User.where(:email => 'dimitri@c12.ge').first }
    its(:photo) { should be_file }
    specify { subject.photo.original_filename.should == 'user_photo.jpg' }
  end
end

