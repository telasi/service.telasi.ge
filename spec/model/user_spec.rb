# -*- encoding : utf-8 -*-

require 'spec_helper'

describe User do
  it { should have_field(:salt).of_type(String) }
  it { should have_field(:hashed_password).of_type(String) }
  it { should have_field(:email).of_type(String) }
  it { should have_field(:mobile).of_type(String) }
  it { should have_field(:first_name).of_type(String) }
  it { should have_field(:last_name).of_type(String) }
  it { should validate_presence_of(:salt) }
  it { should validate_presence_of(:hashed_password) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:mobile) }
  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
end

describe "მომხმარებელზე პაროლის მინიჭება" do
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