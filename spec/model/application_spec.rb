# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Application do
	it { should be_mongoid_document }
	it { should be_timestamped_document }
	it { should have_field(:type).of_type(String) }
	it { should belong_to(:owner).of_type(User) }
	it { should embed_one(:applicant).of_type(Applicant) }
end

describe Applicant do
	it { should be_mongoid_document }
	it { should be_embedded_in(:application).of_type(Application) }
	it { should have_field(:tin).of_type(String) }
	it { should have_field(:name).of_type(String) }
	it { should have_field(:mobile).of_type(String) }
	it { should have_field(:email).of_type(String) }
	it { should have_field(:address).of_type(String) }
end

