require 'capybara/rspec'

RSpec.describe "dashboard/index.html.erb", type: :view do
  it "displays the projects of the user"
  	visit 'dashboard/index'
  	expect(page).to have_content 'My Projects'
  	expect(page).to have_table('table table-striped')
  end
end
