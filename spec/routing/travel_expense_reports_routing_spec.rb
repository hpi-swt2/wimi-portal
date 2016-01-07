require "rails_helper"

RSpec.describe TravelExpenseReportsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(get: "/travel_expense_reports").to route_to("travel_expense_reports#index")
    end

    it "routes to #new" do
      expect(get: "/travel_expense_reports/new").to route_to("travel_expense_reports#new")
    end

    it "routes to #show" do
      expect(get: "/travel_expense_reports/1").to route_to("travel_expense_reports#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/travel_expense_reports/1/edit").to route_to("travel_expense_reports#edit", id: "1")
    end

    it "routes to #create" do
      expect(post: "/travel_expense_reports").to route_to("travel_expense_reports#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/travel_expense_reports/1").to route_to("travel_expense_reports#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/travel_expense_reports/1").to route_to("travel_expense_reports#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/travel_expense_reports/1").to route_to("travel_expense_reports#destroy", id: "1")
    end

  end
end
