require 'rails_helper'

describe 'chair stats' do
  before :each do
    @chair = FactoryGirl.create(:chair)
    @chair2 = FactoryGirl.create(:chair)
    @representative = @chair.representative.user
    @admin = FactoryGirl.create(:wimi, chair: @chair, admin: true).user
    @user1 = FactoryGirl.create(:wimi, chair: @chair).user
  end

  it 'can not be seen by representatives or admins from other chairs' do
    login_as @representative
    visit chair_path(@chair2)

    expect(page).not_to have_content(I18n.t('chairs.show.reporting'))

    login_as @admin
    visit chair_path(@chair2)

    expect(page).not_to have_content(I18n.t('chairs.show.reporting'))
  end

  it  'can be seen by representative or admin belonging to the chair' do
    login_as @representative
    visit chair_path(@chair)

    expect(page).to have_content(I18n.t('chairs.show.reporting'))

    click_on I18n.t('chairs.show.reporting')

    expect(page).to have_http_status(200)

    login_as @admin
    visit chair_path(@chair)

    expect(page).to have_content(I18n.t('chairs.show.reporting'))

    click_on I18n.t('chairs.show.reporting')

    expect(page).to have_http_status(200)
  end
end