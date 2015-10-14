require 'rails_helper'

RSpec.describe 'publications/index', type: :view do
  before(:each) do
    assign(:publications, [
      Publication.create!(title: 'Semantic Web Research Results',
  venue: 'CGM',
  type_: 'Paper',
  project_id: 1),
      Publication.create!(title: 'Semantic Web Research Results',
  venue: 'CGM',
  type_: 'Paper',
  project_id: 1)
    ])
  end

  it 'renders a list of publications' do
    render
  end
end
