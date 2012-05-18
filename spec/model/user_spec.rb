# -*- encoding : utf-8 -*-
require 'spec_helper'

describe User do
  it { should be_mongoid_document }
  it { should have_field(:created_at).of_type(Time) }
  it { should have_field(:updated_at).of_type(Time) }
  it { should have_field(:salt).of_type(String) }
  it { should have_field(:hashed_password).of_type(String) }
  it { should have_field(:email).of_type(String) }
  it { should have_field(:mobile).of_type(String) }
  it { should have_field(:first_name).of_type(String) }
  it { should have_field(:last_name).of_type(String) }
  it { should have_field(:sys_admin).of_type(Boolean) }
  it { should have_field(:new_cust_admin).of_type(Boolean) }
  it { should have_field(:email_confirmed).of_type(Boolean) }
  it { should have_field(:mobile_confirmed).of_type(Boolean) }
  it { should have_field(:email_confirm_hash).of_type(String) }
  it { should have_field(:new_password_hash).of_type(String) }
  it { should validate_presence_of(:salt) }
  it { should validate_presence_of(:hashed_password) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:mobile) }
  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
end

describe "ახალ მომხმარებელზე პაროლის მინიჭება" do
  before(:all) do
    @user = User.new(:password => 'secret')
  end
  subject { @user }
  its(:salt) { should_not be_nil }
  its(:salt) { should_not be_empty }
  its(:hashed_password) { should_not be_nil }
  its(:hashed_password) { should_not be_empty }
  context "დაკრიპტული პაროლი" do
    subject { @user.hashed_password }
    its(:length) { should == 40 }
  end
end

describe "ახალი მომხმარების შექმნა:" do
  context "პირველი მომხმარებელი" do
    before(:all) do
      @user = create(:user, :email => 'dimitri@c12.ge', :mobile => '(595)33-55-14')
    end
    subject { @user }
    its(:sys_admin) { should == true }
    its(:email_confirmed) { should == true }
    its(:mobile_confirmed) { should == false }
    its(:mobile) { should == '595335514' }
    context 'ელ. ფოსტის დადასტურების კოდი' do
      subject { @user.email_confirm_hash }
      it { should be_nil }
    end
  end
  context "მეორე მომხმარებელი" do
    before(:all) do
      @user = create(:user, :email => 'cat.dog@c12.ge')
    end
    subject { @user }
    its(:sys_admin) { should == false }
    its(:email_confirmed) { should == false }
    its(:mobile_confirmed) { should == false }
    context 'ელ. ფოსტის დადასტურების კოდი' do
      subject { @user.email_confirm_hash }
      it { should_not be_nil }
      its(:length) { should == 40 }
    end
  end
end

describe "მომხმარებლის ავტორიზაცია" do
  before(:all) do
    @user = create(:user, :email => 'dimitri@c12.ge', :password => 'secret')
  end
  context "სწორი პაროლით" do
    subject { User.authenticate('dimitri@c12.ge', 'secret') }
    it { should == @user }
  end
  context "არასწორი პაროლით" do
    subject { User.authenticate('dimitri@c12.ge', 'wrong_password') }
    it { should be_nil }
  end
  context "არასწორი ელ. ფოსტის მისამართით" do
    subject { User.authenticate('dimitri@c12.gee', 'secret') }
    it { should be_nil }
  end
end
