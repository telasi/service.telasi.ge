require 'spec_helper'

describe "call/documents/show" do
  before(:each) do
    @call_document = assign(:call_document, stub_model(Call::Document,
      :name => "Name",
      :document => "Document"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/Document/)
  end
end
