require "spec_helper"

describe Call::DocumentsController do
  describe "routing" do

    it "routes to #index" do
      get("/call/documents").should route_to("call/documents#index")
    end

    it "routes to #new" do
      get("/call/documents/new").should route_to("call/documents#new")
    end

    it "routes to #show" do
      get("/call/documents/1").should route_to("call/documents#show", :id => "1")
    end

    it "routes to #edit" do
      get("/call/documents/1/edit").should route_to("call/documents#edit", :id => "1")
    end

    it "routes to #create" do
      post("/call/documents").should route_to("call/documents#create")
    end

    it "routes to #update" do
      put("/call/documents/1").should route_to("call/documents#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/call/documents/1").should route_to("call/documents#destroy", :id => "1")
    end

  end
end
