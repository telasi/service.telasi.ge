require 'spec_helper'

describe "call/call_mobiles/index" do
  before(:each) do
    assign(:call_call_mobiles, [
      stub_model(Call::CallMobile),
      stub_model(Call::CallMobile)
    ])
  end

  it "renders a list of call/call_mobiles" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
