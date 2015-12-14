require 'rails_helper'

RSpec.describe "trips/show", type: :view do
  before(:each) do
    @trip = assign(:trip, FactoryGirl.create(:trip))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Destination/)
    expect(rendered).to match(/Hana Travels/)
    expect(rendered).to match(/HANA pls/)
    expect(rendered).to match(/Signature/)
    expect(rendered).to match(/saved/)
  end

  it "should render links according to the status" do
    #find("a[href='#{author_path(author)}'][data-method='delete']")

    case @trip.status
    when 'saved', 'gespeichert'
      expect(rendered).to have_link('.edit', :default => t("helpers.links.edit"))
      expect(rendered).to have_link('Apply', trips_apply_path(id: @trip), method: post)
    when 'applied', 'gestellt'
      expect(rendered).not_to have_link('.edit', :default => t("helpers.links.edit"))
    else
      expect(rendered).to have_link('.edit', :default => t("helpers.links.edit"))
    end
  end
end
