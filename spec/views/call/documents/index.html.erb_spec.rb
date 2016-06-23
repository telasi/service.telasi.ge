require 'spec_helper'

describe "call/documents/index" do
  before(:each) do
    assign(:call_documents, [
      stub_model(Call::Document,
        :name => "Name",
        :document => "Document"
      ),
      stub_model(Call::Document,
        :name => "Name",
        :document => "Document"
      )
    ])
  end

  it "renders a list of call/documents" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Document".to_s, :count => 2
  end
end
