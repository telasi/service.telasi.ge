require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe Call::DocumentsController do

  # This should return the minimal set of attributes required to create a valid
  # Call::Document. As you add validations to Call::Document, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { "name" => "MyString" } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # Call::DocumentsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all call_documents as @call_documents" do
      document = Call::Document.create! valid_attributes
      get :index, {}, valid_session
      assigns(:call_documents).should eq([document])
    end
  end

  describe "GET show" do
    it "assigns the requested call_document as @call_document" do
      document = Call::Document.create! valid_attributes
      get :show, {:id => document.to_param}, valid_session
      assigns(:call_document).should eq(document)
    end
  end

  describe "GET new" do
    it "assigns a new call_document as @call_document" do
      get :new, {}, valid_session
      assigns(:call_document).should be_a_new(Call::Document)
    end
  end

  describe "GET edit" do
    it "assigns the requested call_document as @call_document" do
      document = Call::Document.create! valid_attributes
      get :edit, {:id => document.to_param}, valid_session
      assigns(:call_document).should eq(document)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Call::Document" do
        expect {
          post :create, {:call_document => valid_attributes}, valid_session
        }.to change(Call::Document, :count).by(1)
      end

      it "assigns a newly created call_document as @call_document" do
        post :create, {:call_document => valid_attributes}, valid_session
        assigns(:call_document).should be_a(Call::Document)
        assigns(:call_document).should be_persisted
      end

      it "redirects to the created call_document" do
        post :create, {:call_document => valid_attributes}, valid_session
        response.should redirect_to(Call::Document.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved call_document as @call_document" do
        # Trigger the behavior that occurs when invalid params are submitted
        Call::Document.any_instance.stub(:save).and_return(false)
        post :create, {:call_document => { "name" => "invalid value" }}, valid_session
        assigns(:call_document).should be_a_new(Call::Document)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Call::Document.any_instance.stub(:save).and_return(false)
        post :create, {:call_document => { "name" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested call_document" do
        document = Call::Document.create! valid_attributes
        # Assuming there are no other call_documents in the database, this
        # specifies that the Call::Document created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Call::Document.any_instance.should_receive(:update_attributes).with({ "name" => "MyString" })
        put :update, {:id => document.to_param, :call_document => { "name" => "MyString" }}, valid_session
      end

      it "assigns the requested call_document as @call_document" do
        document = Call::Document.create! valid_attributes
        put :update, {:id => document.to_param, :call_document => valid_attributes}, valid_session
        assigns(:call_document).should eq(document)
      end

      it "redirects to the call_document" do
        document = Call::Document.create! valid_attributes
        put :update, {:id => document.to_param, :call_document => valid_attributes}, valid_session
        response.should redirect_to(document)
      end
    end

    describe "with invalid params" do
      it "assigns the call_document as @call_document" do
        document = Call::Document.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Call::Document.any_instance.stub(:save).and_return(false)
        put :update, {:id => document.to_param, :call_document => { "name" => "invalid value" }}, valid_session
        assigns(:call_document).should eq(document)
      end

      it "re-renders the 'edit' template" do
        document = Call::Document.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Call::Document.any_instance.stub(:save).and_return(false)
        put :update, {:id => document.to_param, :call_document => { "name" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested call_document" do
      document = Call::Document.create! valid_attributes
      expect {
        delete :destroy, {:id => document.to_param}, valid_session
      }.to change(Call::Document, :count).by(-1)
    end

    it "redirects to the call_documents list" do
      document = Call::Document.create! valid_attributes
      delete :destroy, {:id => document.to_param}, valid_session
      response.should redirect_to(call_documents_url)
    end
  end

end