# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Apps::Application do
	it { should be_mongoid_document }
	it { should be_timestamped_document }
	it { should have_field(:type).of_type(String) }
  it { should have_field(:number).of_type(Integer) }
	it { should have_field(:private).of_type(Boolean) }
	it { should have_field(:total).of_type(Float) }
  it { should have_field(:paid).of_type(Float) }
  it { should have_field(:remaining).of_type(Float) }
	it { should belong_to(:owner).of_type(User) }
	it { should embed_one(:applicant).of_type(Apps::Applicant) }
	it { should embed_one(:new_customer_application).of_type(Apps::NewCustomerApplication) }
  it { should embed_many(:logs).of_type(Log) }
  it { should have_many(:documents).of_type(Document) }
end

describe Apps::Applicant do
	it { should be_mongoid_document }
	it { should be_embedded_in(:application).of_type(Apps::Application) }
	it { should have_field(:tin).of_type(String) }
	it { should have_field(:name).of_type(String) }
	it { should have_field(:mobile).of_type(String) }
	it { should have_field(:email).of_type(String) }
	it { should have_field(:address).of_type(String) }
	it { should have_field(:bank_mfo).of_type(String) }
	it { should have_field(:bank_acc).of_type(String) }
	it { should validate_presence_of(:tin) }
	it { should validate_presence_of(:name) }
	it { should validate_presence_of(:mobile) }
	it { should validate_presence_of(:email) }
	it { should validate_presence_of(:address) }
end

describe Apps::Payment do
  it { should be_mongoid_document }
  it { should be_timestamped_document }
  it { should have_field(:date).of_type(Date) }
  it { should have_field(:amount).of_type(Float) }
  it { should have_field(:comment).of_type(String) }
  it { should belong_to(:application).of_type(Apps::Application) }
end

describe Apps::NewCustomerApplication do
  it { should be_mongoid_document }
  it { should have_field(:status).of_type(Integer) }
  it { should have_field(:voltage).of_type(String) }
  it { should have_field(:amount).of_type(Float) }
  it { should have_field(:days).of_type(Integer) }
  it { should be_embedded_in(:application).of_type(Apps::Application) }
  it { should embed_many(:items).of_type(Apps::NewCustomerItem) }
  it { should embed_many(:calculations).of_type(Apps::NewCustomerCalculation) }
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
  it { should be_embedded_in(:application).of_type(Apps::NewCustomerApplication) }
end

describe Apps::NewCustomerCalculation do
  it { should be_mongoid_document }
  it { should have_field(:voltage).of_type(String) }
  it { should have_field(:power).of_type(Integer) }
  it { should have_field(:tariff_id).of_type(Integer) }
  it { should have_field(:amount).of_type(Float) }
  it { should have_field(:days).of_type(Integer) }
  it { should be_embedded_in(:application).of_type(Apps::NewCustomerApplication) }
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

describe 'ახალი აბონენტის გამოთვლა' do
  before(:all) do
    applicant = Apps::Applicant.new(tin: '02001000490', mobile: '595335514', email: 'dimitri@c12.ge', address: 'ქ. აბაშა, კაჭარავას 35')
    @newapp = Apps::NewCustomerApplication.new
    @app = Apps::Application.new(applicant: applicant, new_customer_application: @newapp, type: Apps::Application::TYPE_NEW_CUSTOMER)
    @app.save ; @newapp.reload
    @newapp.items << Apps::NewCustomerItem.new(voltage: Apps::NewCustomerApplication::VOLTAGE_220, address: 'ქ. თბილისი, ჯიქიას 7', type: Apps::NewCustomerItem::TYPE_SUMMARY, power: 1, personal_use: true)
    @newapp.items << Apps::NewCustomerItem.new(voltage: Apps::NewCustomerApplication::VOLTAGE_220, address: 'ქ. თბილისი, ჯიქიას 7', type: Apps::NewCustomerItem::TYPE_SUMMARY, power: 2, personal_use: true)
    @newapp.save
  end
  context 'აპლიკაციის ანალიზი' do
    subject { @app }
    its(:number) { should be_nil }
    its(:private) { should == true }
  end
  context do
    subject { @newapp }
    it { should_not be_nil }
    its(:items) { should_not be_empty }
    context 'გაანგარიშება' do
      before(:all) do
        @newapp.calculate
      end
      subject { @newapp.calculations }
      it { should_not be_empty }
      its(:size) { should == 1 }
    end
    context 'გაანგარიშების ანალიზი' do
      subject { @newapp.calculations.first }
      its(:power) { should == 3 }
      its(:tariff_id) { should == 1 }
      its(:amount) { should == 800 }
      its(:days) { should == 35 }
    end
  end
  context 'გაგზავნა' do
    before(:all) do
      @resp = @newapp.send!
      @app.reload
    end
    context do
      subject { @resp }
      it { should == true }
    end
    context do
      subject { @newapp }
      its(:status) { should == 1 }
    end
    context do
      subject { @app }
      its(:number) { should == 1 }
      its(:private) { should == false }
    end
  end
end

describe 'ახალი აბონენტის გამოთვლა: 220kv 3 აბონენტი' do
  before(:all) do
    applicant = Apps::Applicant.new(tin: '02001000490', mobile: '595335514', email: 'dimitri@c12.ge', address: 'ქ. აბაშა, კაჭარავას 35')
    @newapp = Apps::NewCustomerApplication.new
    @app = Apps::Application.new(applicant: applicant, new_customer_application: @newapp, type: Apps::Application::TYPE_NEW_CUSTOMER)
    @app.save ; @newapp.reload
    @newapp.items << Apps::NewCustomerItem.new(voltage: Apps::NewCustomerApplication::VOLTAGE_220, address: 'ქ. თბილისი, ჯიქიას 7', type: Apps::NewCustomerItem::TYPE_SUMMARY, power: 9, personal_use: true)
    @newapp.items << Apps::NewCustomerItem.new(voltage: Apps::NewCustomerApplication::VOLTAGE_220, address: 'ქ. თბილისი, ჯიქიას 7', type: Apps::NewCustomerItem::TYPE_SUMMARY, power: 9, personal_use: true)
    @newapp.items << Apps::NewCustomerItem.new(voltage: Apps::NewCustomerApplication::VOLTAGE_220, address: 'ქ. თბილისი, ჯიქიას 7', type: Apps::NewCustomerItem::TYPE_SUMMARY, power: 9, personal_use: true)
    @newapp.save
  end
  context 'აპლიკაციის ანალიზი' do
    subject { @app }
    its(:number) { should be_nil }
    its(:private) { should == true }
  end
  context do
    subject { @newapp }
    it { should_not be_nil }
    its(:items) { should_not be_empty }
    context 'გაანგარიშება' do
      before(:all) do
        @newapp.calculate
      end
      subject { @newapp.calculations }
      it { should_not be_empty }
      its(:size) { should == 1 }
    end
    context 'გაანგარიშების ანალიზი' do
      subject { @newapp.calculations.first }
      its(:power) { should == 27 }
      its(:tariff_id) { should == 3 }
      its(:amount) { should == 4700 }
      its(:days) { should == 40 }
    end
  end
end
