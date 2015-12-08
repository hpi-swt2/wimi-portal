require "rails_helper"

RSpec.describe TimeSheetsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/time_sheets").to route_to("time_sheets#index")
    end

    it "routes to #new" do
      expect(:get => "/time_sheets/new").to route_to("time_sheets#new")
    end

    it "routes to #show" do
      expect(:get => "/time_sheets/1").to route_to("time_sheets#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/time_sheets/1/edit").to route_to("time_sheets#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/time_sheets").to route_to("time_sheets#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/time_sheets/1").to route_to("time_sheets#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/time_sheets/1").to route_to("time_sheets#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/time_sheets/1").to route_to("time_sheets#destroy", :id => "1")
    end

  end
end
