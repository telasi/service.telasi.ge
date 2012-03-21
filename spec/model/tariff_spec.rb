# -*- encoding : utf-8 -*-

require 'spec_helper'

describe 'ყველა ტარიფების ძებნა' do
  before(:all) do
    @tariffs = Tariff2012.all
  end
  subject { @tariffs }
  it { should_not be_nil }
  it { should_not be_empty }
  its(:length) { should == 18 }
  context 'ერთ-ერთი ტარიფის შემოწმება' do
    subject { @tariffs.first }
    its(:id) { should == 1 }
    its(:voltage) { should == '0.220' }
    its(:power) { should == '1-10' }
    its(:complete) { should == 35 }
    its(:price) { should == 400.0 }
  end
end

describe 'ტარიფის ძებნა ID-თი' do
  before(:all) do
    @tariff = Tariff2012.find(13)
  end
  subject { @tariff }
  it { should_not be_nil }
  its(:id) { should == 13 }
end
