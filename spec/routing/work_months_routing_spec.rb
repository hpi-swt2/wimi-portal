require "rails_helper"

RSpec.describe WorkMonthsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/work_months").to route_to("work_months#index")
    end

    it "routes to #new" do
      expect(:get => "/work_months/new").to route_to("work_months#new")
    end

    it "routes to #show" do
      expect(:get => "/work_months/1").to route_to("work_months#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/work_months/1/edit").to route_to("work_months#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/work_months").to route_to("work_months#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/work_months/1").to route_to("work_months#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/work_months/1").to route_to("work_months#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/work_months/1").to route_to("work_months#destroy", :id => "1")
    end

  end
end
