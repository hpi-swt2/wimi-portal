require 'rails_helper'

RSpec.describe 'projects/edit', type: :view do
  before(:each) do
    @project = FactoryGirl.create(:project)
  end

  it 'renders the edit project form' do
    render

    assert_select 'form[action=?][method=?]', project_path(@project), 'post' do
    end
  end
end
