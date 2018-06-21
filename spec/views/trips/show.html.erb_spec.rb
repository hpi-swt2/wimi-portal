require 'rails_helper'

RSpec.describe 'trips/show', type: :view do
  before(:each) do
    user = FactoryBot.create(:user)
    @trip = assign(:trip, FactoryBot.create(:trip, user_id: user.id))
    sign_in user

    # https://github.com/ryanb/cancan/wiki/Testing-Abilities#controller-testing
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Destination/)
    expect(rendered).to match(/Hana Things/)
    expect(rendered).to match(/NYC/)
    expect(rendered).to match(/signature/)
  end

  it 'displays links for editing, applying and destroing when status is not applied' do
    @ability.can :hand_in, Trip
    @ability.can :destroy, Trip
    render
    expect(rendered).to have_link(nil, href: hand_in_trip_path(@trip))
    expect(rendered).to have_link(nil, href: edit_trip_path(@trip))
    expect(rendered).to have_css('a[data-method="delete"]')
  end

  it 'does not display links for editing, applying and destroing when status is applied ' do
    @trip.update({status: 'applied'})
    render
    expect(@trip.status).to eq('applied')
    expect(rendered).not_to have_css("a[href='#{hand_in_trip_path(@trip)}']")
    expect(rendered).not_to have_link(t('helpers.links.destroy'))
  end
end
