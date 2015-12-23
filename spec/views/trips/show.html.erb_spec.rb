require 'rails_helper'

RSpec.describe "trips/show", type: :view do
  before(:each) do
    @trip = assign(:trip, FactoryGirl.create(:trip))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Destination/)
    expect(rendered).to match(/Hana Things/)
    expect(rendered).to match(/NYC/)
    expect(rendered).to match(/signature/)
  end

  it "should render links according to the status" do
  #find("a[href='#{trips_path(@trip)}'][data-method='delete']")
    render
    case @trip.status
    when 'saved', 'gespeichert'
      expect(rendered).to have_link('.edit', :default => t("helpers.links.edit"))
      expect(rendered).to have_link('Apply', trips_apply_path(id: @trip), method: post)
    when 'applied', 'gestellt'
      expect(rendered).not_to have_link('.edit', :default => t("helpers.links.edit"))
      expect(rendered).not_to have_link(t('.destroy', :default => t("helpers.links.destroy")),
                      trip_path(@trip),
                      :method => :delete,
                      :data => { :confirm => t('.confirm', :default => t("helpers.links.confirm", :default => 'Are you sure?')) },
                      :class => 'btn btn-danger')
    else
      expect(rendered).to have_link('.edit', :default => t("helpers.links.edit"))
    end
  end

end
