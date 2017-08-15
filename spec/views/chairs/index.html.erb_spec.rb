require 'rails_helper'

RSpec.describe 'chairs/index.html.erb', type: :view do
  before :each do
    @superadmin = FactoryGirl.create(:user, superadmin: true)
    @chair = FactoryGirl.create(:chair)
  end

  it 'expects buttons for superadmin' do
    login_as(@superadmin, scope: :user)
    visit chairs_path

    expect(page).to have_link(nil, new_chair_path)
    expect(page).to have_link(nil, edit_chair_path(@chair))
  end

  it 'expects buttons for admin' do
    admin = FactoryGirl.create(:user)
    chairwimi = FactoryGirl.create(:wimi, user: admin, chair: @chair, admin: true)
    login_as(admin, scope: :user)
    visit chairs_path

    expect(page).to_not have_css("a[href='#{new_chair_path}']")
    #expect(page).to_not have_content(t('helpers.links.edit'))
    expect(page).to_not have_delete_link(@chair)
  end

  it 'expects buttons for representative' do
    representative = FactoryGirl.create(:user)
    chairwimi = ChairWimi.create(user: representative, chair: @chair, representative: true)
    login_as(representative, scope: :user)
    visit chairs_path

    expect(page).to_not have_css("a[href='#{new_chair_path}']")
    #expect(page).to_not have_content(t('helpers.links.edit'))
    expect(page).to_not have_delete_link(@chair)
  end

  it 'expects buttons for users' do
    user = FactoryGirl.create(:user)
    login_as(user, scope: :user)
    visit chairs_path

    expect(page).to have_link(nil, new_chair_path)
    expect(page).to have_link(nil, edit_chair_path(@chair))
    expect(page).to_not have_delete_link(@chair)
  end

  it 'tests functionality of New Button' do
    login_as(@superadmin, scope: :user)
    visit chairs_path

    click_on t('helpers.links.new')
    expect(page).to have_current_path(new_chair_path)
  end

  it 'tests functionality of Edit Button in the table' do
    login_as(@superadmin, scope: :user)
    visit chairs_path

    click_on t('helpers.links.edit_short')
    expect(page).to have_current_path(edit_chair_path(@chair))
  end
end
