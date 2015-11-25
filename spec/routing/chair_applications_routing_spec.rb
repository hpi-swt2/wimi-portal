require "rails_helper"

RSpec.describe ChairApplicationsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/chair_applications").to route_to("chair_applications#index")
    end

    it "routes to #new" do
      expect(:get => "/chair_applications/new").to route_to("chair_applications#new")
    end

    it "routes to #show" do
      expect(:get => "/chair_applications/1").to route_to("chair_applications#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/chair_applications/1/edit").to route_to("chair_applications#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/chair_applications").to route_to("chair_applications#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/chair_applications/1").to route_to("chair_applications#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/chair_applications/1").to route_to("chair_applications#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/chair_applications/1").to route_to("chair_applications#destroy", :id => "1")
    end

  end
end
