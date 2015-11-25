require "rails_helper"

RSpec.describe ChairWimisController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/chair_wimis").to route_to("chair_wimis#index")
    end

    it "routes to #new" do
      expect(:get => "/chair_wimis/new").to route_to("chair_wimis#new")
    end

    it "routes to #show" do
      expect(:get => "/chair_wimis/1").to route_to("chair_wimis#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/chair_wimis/1/edit").to route_to("chair_wimis#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/chair_wimis").to route_to("chair_wimis#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/chair_wimis/1").to route_to("chair_wimis#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/chair_wimis/1").to route_to("chair_wimis#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/chair_wimis/1").to route_to("chair_wimis#destroy", :id => "1")
    end

  end
end
