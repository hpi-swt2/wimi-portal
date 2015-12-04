require "rails_helper"

RSpec.describe ProjectApplicationsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/project_applications").to route_to("project_applications#index")
    end

    it "routes to #create" do
      expect(:post => "/project_applications/apply/project_1").to route_to("project_applications#create", :id => "1")
    end

    it "routes to #accept" do
      expect(:get => "/project_applications/1/accept").to route_to("project_applications#accept", :id => "1")
    end

    it "routes to #decline" do
      expect(:get => "/project_applications/1/decline").to route_to("project_applications#decline", :id => "1")
    end

    it "routes to #reapply" do
      expect(:get => "/project_applications/1/reapply").to route_to("project_applications#reapply", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/project_applications/1").to route_to("project_applications#destroy", :id => "1")
    end

  end
end
