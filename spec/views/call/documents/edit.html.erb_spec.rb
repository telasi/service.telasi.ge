require 'spec_helper'

describe "call/documents/edit" do
  before(:each) do
    @call_document = assign(:call_document, stub_model(Call::Document,
      :name => "MyString",
      :document => "MyString"
    ))
  end

  it "renders the edit call_document form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", call_document_path(@call_document), "post" do
      assert_select "input#call_document_name[name=?]", "call_document[name]"
      assert_select "input#call_document_document[name=?]", "call_document[document]"
    end
  end
end
