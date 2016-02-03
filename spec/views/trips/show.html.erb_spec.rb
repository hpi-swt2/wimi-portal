require 'rails_helper'

RSpec.describe 'trips/show', type: :view do
  before(:each) do
    user = FactoryGirl.create(:user)
    @trip = assign(:trip, FactoryGirl.create(:trip, user_id: user.id))
    sign_in user
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Destination/)
    expect(rendered).to match(/Hana Things/)
    expect(rendered).to match(/NYC/)
    expect(rendered).to match(/signature/)
  end

  it 'displays links for editing, applying and destroing when status is not applied' do
    render
    expect(rendered).to have_link(t('helpers.links.hand_in'))
    expect(rendered).to have_link(t('helpers.links.edit'))
    expect(rendered).to have_link(t('helpers.links.destroy'))
  end

  it 'does not display links for editing, applying and destroing when status is applied ' do
    @trip.update({status: 'applied'})
    render
    expect(@trip.status).to eq('applied')
    expect(rendered).not_to have_link(t('helpers.links.hand_in'))
    expect(rendered).not_to have_link(t('helpers.links.destroy'))
  end

  it 'denies the superadmin to see trip details' do
    superadmin = FactoryGirl.create(:user, superadmin: true)
    login_as superadmin
    visit trip_path(@trip)
    expect(current_path).to eq(dashboard_path)
  end
end
