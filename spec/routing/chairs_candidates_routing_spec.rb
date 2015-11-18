require "rails_helper"

RSpec.describe ChairsCandidatesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/chairs_candidates").to route_to("chairs_candidates#index")
    end

    it "routes to #new" do
      expect(:get => "/chairs_candidates/new").to route_to("chairs_candidates#new")
    end

    it "routes to #show" do
      expect(:get => "/chairs_candidates/1").to route_to("chairs_candidates#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/chairs_candidates/1/edit").to route_to("chairs_candidates#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/chairs_candidates").to route_to("chairs_candidates#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/chairs_candidates/1").to route_to("chairs_candidates#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/chairs_candidates/1").to route_to("chairs_candidates#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/chairs_candidates/1").to route_to("chairs_candidates#destroy", :id => "1")
    end

  end
end
