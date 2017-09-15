require 'spec_helper'

describe "call/call_mobiles/edit" do
  before(:each) do
    @call_call_mobile = assign(:call_call_mobile, stub_model(Call::CallMobile))
  end

  it "renders the edit call_call_mobile form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", call_call_mobile_path(@call_call_mobile), "post" do
    end
  end
end
