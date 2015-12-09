require 'rails_helper'

RSpec.describe 'projects/index', type: :view do
  before(:each) do
    @projects = [FactoryGirl.create(:project),
                 FactoryGirl.create(:project)
    ]
  end

  it 'renders a list of projects' do
    render
  end
end
