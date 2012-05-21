# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Log do
  it { should be_mongoid_document }
  it { should be_timestamped_document }
  it { should have_field(:type).of_type(String) }
  it { should have_field(:text).of_type(String) }
  it { should belong_to(:user) }
  it { should be_embedded_in(:loggable) }
end
