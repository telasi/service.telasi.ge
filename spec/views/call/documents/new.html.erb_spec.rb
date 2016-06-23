require 'spec_helper'

describe "call/documents/new" do
  before(:each) do
    assign(:call_document, stub_model(Call::Document,
      :name => "MyString",
      :document => "MyString"
    ).as_new_record)
  end

  it "renders new call_document form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", call_documents_path, "post" do
      assert_select "input#call_document_name[name=?]", "call_document[name]"
      assert_select "input#call_document_document[name=?]", "call_document[document]"
    end
  end
end
