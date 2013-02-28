# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Bs::Mongo::Customer do
  it { should be_mongoid_document }
  it { should be_timestamped_document }
  it { should have_field(:custkey).of_type(Integer) }
  it { should have_field(:note).of_type(String) }
  it { should have_field(:accnumb).of_type(String) }
  it { should have_field(:custname).of_type(String) }
  it { should have_field(:comercial).of_type(String) }
  it { should have_field(:createdate).of_type(Date) }
  it { should have_field(:closedate).of_type(Date) }
  it { should have_field(:tel).of_type(String) }
  it { should have_field(:fax).of_type(String) }
  it { should have_field(:email).of_type(String) }
  it { should have_field(:taxid).of_type(String) }
  it { should have_field(:contact).of_type(String) }
  it { should have_field(:balance).of_type(Float) }
  it { should have_field(:old_balance).of_type(Float) }
  it { should have_field(:illegalline).of_type(Boolean) }
  it { should have_field(:except).of_type(Boolean) }
  it { should have_field(:goodpayer).of_type(Boolean) }
  it { should have_field(:payint).of_type(Integer) }
  it { should have_field(:cut).of_type(Boolean) }
  it { should have_field(:status).of_type(Integer) }
  it { should embed_one(:address).of_type(Bs::Mongo::Address) }
  it { should embed_one(:send_address).of_type(Bs::Mongo::Address) }
  it { should embed_one(:category).of_type(Bs::Mongo::CustomerCategory) }
  it { should embed_one(:activity).of_type(Bs::Mongo::CustomerCategory) }
end

describe Bs::Mongo::Address do
  it { should be_mongoid_document }
  it { should have_field(:premisekey).of_type(Integer) }
  it { should have_field(:regionkey).of_type(Integer) }
  it { should have_field(:regionname).of_type(String) }
  it { should have_field(:streetkey).of_type(Integer) }
  it { should have_field(:streetname).of_type(String) }
  it { should have_field(:house).of_type(String) }
  it { should have_field(:building).of_type(String) }
  it { should have_field(:porch).of_type(String) }
  it { should have_field(:flate).of_type(String) }
  it { should have_field(:postindex).of_type(String) }
  it { should have_field(:roomnumber).of_type(Integer) }
  it { should have_field(:read_seq).of_type(Integer) }
end

describe Bs::Mongo::CustomerCategory do
  it { should be_mongoid_document }
  it { should have_field(:custcatkey).of_type(Integer) }
  it { should have_field(:custcatname).of_type(String) }
end
