require 'rails_helper'

RSpec.describe 'projects/show', type: :view do
  before(:each) do
    login_as FactoryGirl.create(:user)
    @project = FactoryGirl.create(:project)
  end

  it 'renders attributes in <p>' do
    render
  end
end
