# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Apps::Application do
	it { should be_mongoid_document }
	it { should be_timestamped_document }
	it { should have_field(:type).of_type(String) }
	it { should belong_to(:owner).of_type(User) }
	it { should embed_one(:applicant).of_type(Apps::Applicant) }
	it { should embed_one(:new_customer_application).of_type(Apps::NewCustomerApplication) }
end

describe Apps::Applicant do
	it { should be_mongoid_document }
	it { should be_embedded_in(:application).of_type(Apps::Application) }
	it { should have_field(:tin).of_type(String) }
	it { should have_field(:name).of_type(String) }
	it { should have_field(:mobile).of_type(String) }
	it { should have_field(:email).of_type(String) }
	it { should have_field(:address).of_type(String) }
	it { should validate_presence_of(:tin) }
	it { should validate_presence_of(:name) }
	it { should validate_presence_of(:mobile) }
	it { should validate_presence_of(:email) }
	it { should validate_presence_of(:address) }
end

describe Apps::NewCustomerApplication do
  it { should be_mongoid_document }
  it { should have_field(:status).of_type(Integer) }
  it { should have_field(:voltage).of_type(String) }
  it { should have_field(:power).of_type(Float) }
  it { should have_field(:tariff).of_type(Integer) }
  it { should be_embedded_in(:application).of_type(Apps::Application) }
end

describe Apps::NewCustomerItem do
  it { should be_mongoid_document }
  it { should be_timestamped_document }
  it { should have_field(:type).of_type(String) }
  it { should have_field(:address).of_type(String) }
  it { should have_field(:voltage).of_type(String) }
  it { should have_field(:power).of_type(Float) }
  it { should have_field(:personal_use).of_type(Boolean) }
  it { should have_field(:count).of_type(Integer) }
  it { should have_field(:tin).of_type(String) }
  it { should have_field(:name).of_type(String) }
end

describe 'ახალი აბონენტის ტარიფების ინიციალიზაცია' do
  before(:all) do
    @tariffs = Apps::NewCustomerTariff.tariffs
  end
  context 'რაოდენობის ანალიზი' do
    subject { @tariffs }
    it { should_not be_nil }
    it { should_not be_empty }
    its(:size) { should == 18 }
  end
  context 'პირველი ტარიფი' do
    subject { @tariffs.first }
    its(:id) { should == 1 }
    its(:voltage) { should == '0.220' }
    its(:voltage_alt) { should == '220 ვ' }
    its(:power_from) { should == 1 }
    its(:power_to) { should == 10 }
    its(:days_to_complete) { should == 35 }
    its(:price_gel) { should == 400 }
  end
end
