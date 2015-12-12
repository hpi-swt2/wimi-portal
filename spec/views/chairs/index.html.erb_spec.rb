require 'rails_helper'

RSpec.describe "chairs/index", type: :view do
  before(:each) do
    @user = FactoryGirl.create(:user, :role => 'superadmin')
    sign_in(@user)
  end

  it "renders a list of chairs" do
    assign(:chairs, [
      Chair.create!,
      Chair.create!
    ])
    render
  end

  it "goes to the chair creation page and cancels the creation" do
    login_as(@user, :scope => :user)
    visit(chairs_path)
    expect(page).to have_content('New')
    click_on("New")
    expect(page).to have_text('New Chair')
    expect(page).to have_current_path(new_chair_path)
    click_on('Cancel')
    expect(page).to have_text('Chairs')
    expect(page).to have_current_path(chairs_path)
  end

  it "goes to the chair editing page and changes the title" do
    login_as(@user, :scope => :user)
    tempuser1 = FactoryGirl.create(:user)
    tempuser2 = FactoryGirl.create(:user)
    chair = FactoryGirl.create(:chair, :name => 'TempChair')
    chairadmin = FactoryGirl.create(:chair_admin, :chair_id => chair.id, :user_id => tempuser1.id)
    chairrepresentative = FactoryGirl.create(:chair_representative, :chair_id => chair.id, :user_id => tempuser2.id)
    visit(chairs_path)
    expect(page).to have_text('TempChair')
    expect(page).to have_content('Edit')
    click_on('Edit')
    expect(page).to have_text('Edit Chair')
    expect(page).to have_current_path(edit_chair_path(chair))
    fill_in('Name', :with => 'NewTempChair')
    click_on('Update Chair')
    expect(page).to have_text('Chairs')
    expect(page).to have_current_path(chairs_path)
    expect(page).to have_content('NewTempChair')
  end

  it "tries to click on New button without permissions" do
    tempuser = FactoryGirl.create(:user, :role => 'user')
    login_as(tempuser, :scope => :user)
    visit(chairs_path)
    expect(page).not_to have_content('New')
  end

  it "tries to click on Edit button without permissions" do
    tempuser = FactoryGirl.create(:user, :role => 'user')
    login_as(tempuser, :scope => :user)
    tempuser1 = FactoryGirl.create(:user)
    tempuser2 = FactoryGirl.create(:user)
    chair = FactoryGirl.create(:chair, :name => 'TempChair')
    chairadmin = FactoryGirl.create(:chair_admin, :chair_id => chair.id, :user_id => tempuser1.id)
    chairrepresentative = FactoryGirl.create(:chair_representative, :chair_id => chair.id, :user_id => tempuser2.id)
    visit(chairs_path)
    expect(page).to have_text('TempChair')
    expect(page).not_to have_content('Edit')
  end

end
