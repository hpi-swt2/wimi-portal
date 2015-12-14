require 'rails_helper'

RSpec.describe 'dashboard/index.html.erb', type: :view do
  before :each do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  it 'displays the projects of the user' do
    project1 = FactoryGirl.create(:project)
    project2 = FactoryGirl.create(:project, title: 'Unassigned Project')
    project1.users << @user
    render
    expect(rendered).to have_content('My Projects')
    expect(rendered).to have_content(project1.title)
    expect(rendered).to_not have_content(project2.title)
  end

  it 'shows a notification once after the user has been invited' do
    Notification.create(user: @user, message: 'You have been invited to a project')
    sign_in @user
    render
    expect(rendered).to have_content('You have been invited to a project')
    expect(Notification.where(user: @user).size).to eq 0
  end
end
