require 'spec_helper'

describe "call/call_mobiles/new" do
  before(:each) do
    assign(:call_call_mobile, stub_model(Call::CallMobile).as_new_record)
  end

  it "renders new call_call_mobile form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", call_call_mobiles_path, "post" do
    end
  end
end
