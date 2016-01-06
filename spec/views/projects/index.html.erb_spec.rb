require 'rails_helper'

RSpec.describe 'projects/index', type: :view do
  before(:each) do
    assign(:projects, [
      Project.create!(title: 'My Project'),
      Project.create!(title: 'My Project')
    ])
  end

  it 'renders a list of projects' do
    render
  end
end
