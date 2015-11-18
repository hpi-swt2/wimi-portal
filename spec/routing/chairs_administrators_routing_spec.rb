require "rails_helper"

RSpec.describe ChairsAdministratorsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/chairs_administrators").to route_to("chairs_administrators#index")
    end

    it "routes to #new" do
      expect(:get => "/chairs_administrators/new").to route_to("chairs_administrators#new")
    end

    it "routes to #show" do
      expect(:get => "/chairs_administrators/1").to route_to("chairs_administrators#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/chairs_administrators/1/edit").to route_to("chairs_administrators#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/chairs_administrators").to route_to("chairs_administrators#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/chairs_administrators/1").to route_to("chairs_administrators#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/chairs_administrators/1").to route_to("chairs_administrators#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/chairs_administrators/1").to route_to("chairs_administrators#destroy", :id => "1")
    end

  end
end
