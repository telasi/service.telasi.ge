# -*- encoding : utf-8 -*-

require 'spec_helper'

describe Application do
  it { should be_mongoid_document }
  it { should have_field(:created_at).of_type(Time) }
  it { should have_field(:updated_at).of_type(Time) }
  it { should have_field(:type).of_type(Integer) }
  it { should have_field(:status).of_type(Integer) }
  it { should have_field(:address).of_type(String) }
  it { should have_field(:address_code).of_type(String) }
  it { should have_field(:written_response).of_type(Boolean) }
  it { should have_field(:email_response).of_type(Boolean) }
  it { should have_field(:send_date).of_type(Time) }
  it { should have_field(:response_date).of_type(Time) }
  it { should have_field(:close_date).of_type(Time) }
  it { should have_field(:tariff_id).of_type(Integer) }
  it { should belong_to(:owner).of_type(User) }
  it { should embed_one(:applicant).of_type(Applicant) }
  it { should embed_one(:bank_account).of_type(BankAccount) }
end

describe Applicant do
  it { should be_mongoid_document }
  it { should have_field(:tin).of_type(String) }
  it { should have_field(:name).of_type(String) }
  it { should have_field(:address).of_type(String) }
  it { should have_field(:mobile).of_type(String) }
  it { should have_field(:email).of_type(String) }
  it { should be_embedded_in(:application) }
  it { should validate_presence_of(:tin) }
  it { should validate_presence_of(:address) }
  it { should validate_presence_of(:mobile) }
end

describe BankAccount do
  it { should be_mongoid_document }
  it { should have_field(:swift).of_type(String) }
  it { should have_field(:bank).of_type(String) }
  it { should have_field(:eban).of_type(String) }
  it { should be_embedded_in(:application) }
end

describe 'განცხადების PDF-ის დაბეჭდვა' do
  before(:all) do
    @application = Factory(:application)
  end
  subject { @application }
  it { should_not be_nil }
  it { should_not be_new }
end