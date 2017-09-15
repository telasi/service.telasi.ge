require 'spec_helper'

describe "call/call_mobiles/show" do
  before(:each) do
    @call_call_mobile = assign(:call_call_mobile, stub_model(Call::CallMobile))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
