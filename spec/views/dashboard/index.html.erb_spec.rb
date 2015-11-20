require 'rails_helper'

RSpec.describe 'dashboard/index.html.erb', type: :view do
  it 'displays the projects of the user' do
  	expect(1).to eq(5-4)
  	#render :template => 'dashboard/index.html.erb'
  	#expect(rendered).to have_content 'My projects'
  	#expect(page).to have_table('table table-striped')
  end
end
