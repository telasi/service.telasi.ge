# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Application do
	it { should be_mongoid_document }
	it { should be_timestamped_document }
	it { should have_field(:type).of_type(String) }
	it { should belong_to(:owner).of_type(User) }
	it { should embed_one(:applicant).of_type(Applicant) }
	it { should embed_one(:new_customer_application).of_type(NewCustomerApplication) }
end

describe Applicant do
	it { should be_mongoid_document }
	it { should be_embedded_in(:application).of_type(Application) }
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

describe NewCustomerApplication do
	it { should be_mongoid_document }
	it { should be_embedded_in(:application).of_type(Application) }
end

