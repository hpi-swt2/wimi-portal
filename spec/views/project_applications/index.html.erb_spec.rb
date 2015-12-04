require 'spec_helper'
require 'rails_helper'

RSpec.describe "project_applications/index", type: :view do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @projects = [FactoryGirl.create(:user),
                 FactoryGirl.create(:wimi).projects.first]
    login_as(@user)

    for project in @projects
      visit project_path(project)
      click_on(I18n.t('helpers.links.apply'))
    end
  end

  it "renders a list of project_applications" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
  end
end
