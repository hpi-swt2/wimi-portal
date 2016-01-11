require 'rails_helper'

RSpec.describe "chairs/index.html.erb", type: :view do
  before :each do
    @superadmin = FactoryGirl.create(:user)
    @superadmin.superadmin = true
  end

  it 'expects buttons for superadmin' do
    @chair = FactoryGirl.create(:chair)
    login_as(@superadmin, scope: :user)
    visit chairs_path

    expect(page).to have_content('New')
    expect(page).to have_content('Edit Chair')
    expect(page).to have_content('Destroy Chair')

    expect(page).to_not have_content('Manage Chair')
    expect(page).to_not have_content('Apply as Wimi')
  end

  it 'expects buttons for admin' do
    @chair = FactoryGirl.create(:chair)
    @admin = FactoryGirl.create(:user)
    @chairwimi = FactoryGirl.create(:chair_wimi, user: @admin, chair: @chair, admin: true)
    login_as(@admin, :scope => :user)
    visit chairs_path

    expect(page).to have_content('Manage Chair')

    expect(page).to_not have_content('New')
    expect(page).to_not have_content('Edit Chair')
    expect(page).to_not have_content('Destroy Chair')
    expect(page).to_not have_content('Apply as Wimi')
  end

  it 'expects buttons for representative' do
    @chair = FactoryGirl.create(:chair)
    @representative = FactoryGirl.create(:user)
    @chairwimi = ChairWimi.create(user: @representative, chair: @chair, representative: true)
    login_as(@representative, scope: :user)
    visit chairs_path

    expect(page).to have_content('Manage Chair')

    expect(page).to_not have_content('New')
    expect(page).to_not have_content('Edit Chair')
    expect(page).to_not have_content('Destroy Chair')
    expect(page).to_not have_content('Apply as Wimi')
  end

  it 'expects buttons for users' do
    @chair = FactoryGirl.create(:chair)
    @user = FactoryGirl.create(:user)
    login_as(@user, scope: :user)
    visit chairs_path

    expect(page).to have_content('Apply as Wimi')

    expect(page).to_not have_content('New')
    expect(page).to_not have_content('Edit Chair')
    expect(page).to_not have_content('Destroy Chair')
    expect(page).to_not have_content('Manage Chair')
  end

  it 'tests functionality of New Button' do
    @chair = FactoryGirl.create(:chair)
    login_as(@superadmin, scope: :user)
    visit chairs_path

    click_on 'New'
    expect(page).to have_current_path(new_chair_path)
  end

  it 'tests functionality of Edit Button' do
    @chair = FactoryGirl.create(:chair)
    login_as(@superadmin, scope: :user)
    visit chairs_path

    click_on 'Edit Chair'
    expect(page).to have_current_path(edit_chair_path(@chair))
  end

  it 'tests functionality of Destroy Button' do
    @chair = FactoryGirl.create(:chair)
    login_as(@superadmin, scope: :user)
    visit chairs_path

    expect(page).to have_content('TestChair')
    click_on 'Destroy Chair'
    expect(page).to have_current_path(chairs_path)
    expect(page).to_not have_content('TestChair')
  end

  it 'tests functionality of Manage Button' do
    @chair = FactoryGirl.create(:chair)
    @representative = FactoryGirl.create(:user)
    @chairwimi = ChairWimi.create(user: @representative, chair: @chair, representative: true)
    login_as(@representative, scope: :user)
    visit chairs_path

    click_on 'Manage Chair'
    expect(page).to have_current_path(chair_path(@chair))
  end

  it 'tests functionality of Apply Button' do
    @chair = FactoryGirl.create(:chair)
    @user = FactoryGirl.create(:user)
    login_as(@user, scope: :user)
    visit chairs_path

    expect(page).to_not have_content('pending')
    click_on 'Apply as Wimi'
    expect(page).to have_current_path(chairs_path)
    expect(page).to have_content('pending')
  end
end
