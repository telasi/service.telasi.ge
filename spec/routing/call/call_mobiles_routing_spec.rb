require "spec_helper"

describe Call::CallMobilesController do
  describe "routing" do

    it "routes to #index" do
      get("/call/call_mobiles").should route_to("call/call_mobiles#index")
    end

    it "routes to #new" do
      get("/call/call_mobiles/new").should route_to("call/call_mobiles#new")
    end

    it "routes to #show" do
      get("/call/call_mobiles/1").should route_to("call/call_mobiles#show", :id => "1")
    end

    it "routes to #edit" do
      get("/call/call_mobiles/1/edit").should route_to("call/call_mobiles#edit", :id => "1")
    end

    it "routes to #create" do
      post("/call/call_mobiles").should route_to("call/call_mobiles#create")
    end

    it "routes to #update" do
      put("/call/call_mobiles/1").should route_to("call/call_mobiles#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/call/call_mobiles/1").should route_to("call/call_mobiles#destroy", :id => "1")
    end

  end
end
