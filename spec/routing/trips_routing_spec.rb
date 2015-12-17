require "rails_helper"

RSpec.describe TripsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/trips").to route_to("trips#index")
    end

    it "routes to #new" do
      expect(:get => "/trips/new").to route_to("trips#new")
    end

    it "routes to #show" do
      expect(:get => "/trips/1").to route_to("trips#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/trips/1/edit").to route_to("trips#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/trips").to route_to("trips#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/trips/1").to route_to("trips#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/trips/1").to route_to("trips#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/trips/1").to route_to("trips#destroy", :id => "1")
    end

  end
end
