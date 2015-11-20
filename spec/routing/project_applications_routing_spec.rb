require "rails_helper"

RSpec.describe ProjectApplicationsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/project_applications").to route_to("project_applications#index")
    end

    it "routes to #new" do
      expect(:get => "/project_applications/new").to route_to("project_applications#new")
    end

    it "routes to #show" do
      expect(:get => "/project_applications/1").to route_to("project_applications#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/project_applications/1/edit").to route_to("project_applications#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/project_applications").to route_to("project_applications#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/project_applications/1").to route_to("project_applications#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/project_applications/1").to route_to("project_applications#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/project_applications/1").to route_to("project_applications#destroy", :id => "1")
    end

  end
end
