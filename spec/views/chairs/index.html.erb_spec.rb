require 'rails_helper'

RSpec.describe 'chairs/index.html.erb', type: :view do
  before :each do
    @superadmin = FactoryGirl.create(:user, superadmin: true)
  end

  it 'expects buttons for superadmin' do
    chair = FactoryGirl.create(:chair)
    login_as(@superadmin, scope: :user)
    visit chairs_path

    expect(page).to have_content(t('helpers.links.new'))
    expect(page).to have_content(t('helpers.links.edit'))
  end

  it 'expects buttons for admin' do
    chair = FactoryGirl.create(:chair)
    admin = FactoryGirl.create(:user)
    chairwimi = FactoryGirl.create(:wimi, user: admin, chair: chair, admin: true)
    login_as(admin, scope: :user)
    visit chairs_path

    expect(page).to_not have_content(t('helpers.links.new'))
    #expect(page).to_not have_content(t('helpers.links.edit'))
    expect(page).to_not have_content(t('helpers.links.destroy'))
  end

  it 'expects buttons for representative' do
    chair = FactoryGirl.create(:chair)
    representative = FactoryGirl.create(:user)
    chairwimi = ChairWimi.create(user: representative, chair: chair, representative: true)
    login_as(representative, scope: :user)
    visit chairs_path

    expect(page).to_not have_content(t('helpers.links.new'))
    #expect(page).to_not have_content(t('helpers.links.edit'))
    expect(page).to_not have_content(t('helpers.links.destroy'))
  end

  it 'expects buttons for users' do
    chair = FactoryGirl.create(:chair)
    user = FactoryGirl.create(:user)
    login_as(user, scope: :user)
    visit chairs_path

    expect(page).to_not have_content(t('helpers.links.new'))
    expect(page).to_not have_content(t('helpers.links.edit'))
    expect(page).to_not have_content(t('helpers.links.destroy'))
  end

  it 'tests functionality of New Button' do
    chair = FactoryGirl.create(:chair)
    login_as(@superadmin, scope: :user)
    visit chairs_path

    click_on t('helpers.links.new')
    expect(page).to have_current_path(new_chair_path)
  end

  it 'tests functionality of Edit Button' do
    chair = FactoryGirl.create(:chair)
    login_as(@superadmin, scope: :user)
    visit chairs_path

    click_on t('helpers.links.edit')
    expect(page).to have_current_path(edit_chair_path(chair))
  end
end
