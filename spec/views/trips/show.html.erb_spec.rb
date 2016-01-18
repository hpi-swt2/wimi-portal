require 'rails_helper'

RSpec.describe 'trips/show', type: :view do
  before(:each) do
    @trip = assign(:trip, FactoryGirl.create(:trip))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Destination/)
    expect(rendered).to match(/Hana Things/)
    expect(rendered).to match(/NYC/)
    expect(rendered).to match(/signature/)
  end

  it "displays links for editing, applying ind destroing when status is not applied" do
    render
    expect(rendered).to have_link(t('helpers.links.hand_in'))
    expect(rendered).to have_link(t('helpers.links.edit'))
    expect(rendered).to have_link(t('helpers.links.destroy'))
  end

  it "does not display links for editing, applying ind destroing when status is applied " do
    @trip.update({status: 'applied'})
    render
    expect(@trip.status).to eq('applied')
    expect(rendered).to have_content(t('status.applied'))
    expect(rendered).not_to have_link(t('helpers.links.hand_in'))
    expect(rendered).not_to have_link(t('helpers.links.edit'))
    expect(rendered).not_to have_link(t('helpers.links.destroy'))
  end

end
