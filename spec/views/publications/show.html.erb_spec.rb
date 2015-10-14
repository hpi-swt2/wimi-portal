require 'rails_helper'

RSpec.describe 'publications/show', type: :view do
  before(:each) do
    @publication = assign(:publication, Publication.create!(title: 'Semantic Web Research Results',
  venue: 'CGM',
  type_: 'Paper',
  project_id: 1))
  end

  it 'renders attributes in <p>' do
    render
  end
end
