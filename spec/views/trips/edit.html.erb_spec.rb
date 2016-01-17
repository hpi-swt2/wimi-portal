require 'rails_helper'

RSpec.describe 'trips/edit', type: :view do
  before(:each) do
    @trip = assign(:trip, FactoryGirl.create(:trip))
  end

  it 'renders the edit trip form' do
    render

    assert_select 'form[action=?][method=?]', trip_path(@trip), 'post' do
      assert_select 'input#trip_destination[name=?]', 'trip[destination]'

      assert_select 'textarea#trip_reason[name=?]', 'trip[reason]'

      assert_select 'textarea#trip_annotation[name=?]', 'trip[annotation]'

      assert_select 'input#trip_signature[name=?]', 'trip[signature]'
    end
  end

  it "shows the trip detail page after editing" do
      @user = FactoryGirl.create(:user)
      login_as @user
      visit trip_path(@trip)
      click_on I18n.t('helpers.links.edit')
      find('input[name="commit"]').click
      expect(current_path).to eq(trip_path(@trip))
  end
end
