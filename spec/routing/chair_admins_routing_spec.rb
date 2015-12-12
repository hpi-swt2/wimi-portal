require "rails_helper"

RSpec.describe ChairAdminsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/chair_admins").to route_to("chair_admins#index")
    end

    it "routes to #new" do
      expect(:get => "/chair_admins/new").to route_to("chair_admins#new")
    end

    it "routes to #show" do
      expect(:get => "/chair_admins/1").to route_to("chair_admins#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/chair_admins/1/edit").to route_to("chair_admins#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/chair_admins").to route_to("chair_admins#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/chair_admins/1").to route_to("chair_admins#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/chair_admins/1").to route_to("chair_admins#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/chair_admins/1").to route_to("chair_admins#destroy", :id => "1")
    end

  end
end
