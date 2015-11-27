require 'rails_helper'

RSpec.describe 'dashboard/index.html.erb', type: :view do
  it 'displays the projects of the user' do
    user = FactoryGirl.create(:user)
    sign_in user
    render
    expect(rendered).to have_content('My Projects')
  end
end
