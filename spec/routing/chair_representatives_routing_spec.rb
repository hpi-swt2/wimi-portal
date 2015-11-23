require "rails_helper"

RSpec.describe ChairRepresentativesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/chair_representatives").to route_to("chair_representatives#index")
    end

    it "routes to #new" do
      expect(:get => "/chair_representatives/new").to route_to("chair_representatives#new")
    end

    it "routes to #show" do
      expect(:get => "/chair_representatives/1").to route_to("chair_representatives#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/chair_representatives/1/edit").to route_to("chair_representatives#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/chair_representatives").to route_to("chair_representatives#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/chair_representatives/1").to route_to("chair_representatives#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/chair_representatives/1").to route_to("chair_representatives#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/chair_representatives/1").to route_to("chair_representatives#destroy", :id => "1")
    end

  end
end
