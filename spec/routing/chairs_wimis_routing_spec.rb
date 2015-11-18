require "rails_helper"

RSpec.describe ChairsWimisController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/chairs_wimis").to route_to("chairs_wimis#index")
    end

    it "routes to #new" do
      expect(:get => "/chairs_wimis/new").to route_to("chairs_wimis#new")
    end

    it "routes to #show" do
      expect(:get => "/chairs_wimis/1").to route_to("chairs_wimis#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/chairs_wimis/1/edit").to route_to("chairs_wimis#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/chairs_wimis").to route_to("chairs_wimis#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/chairs_wimis/1").to route_to("chairs_wimis#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/chairs_wimis/1").to route_to("chairs_wimis#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/chairs_wimis/1").to route_to("chairs_wimis#destroy", :id => "1")
    end

  end
end
