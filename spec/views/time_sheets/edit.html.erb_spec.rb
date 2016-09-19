require 'rails_helper'

RSpec.describe 'time_sheets/edit', type: :view do
  before(:each) do
    @time_sheet = assign(:time_sheet, FactoryGirl.create(:time_sheet))
  end

  it 'renders the edit time_sheet form' do
    render

    assert_select 'form[action=?][method=?]', time_sheet_path(@time_sheet), 'post' do

    end
  end

  it 'has input fields for work day projects' do
  	render

  	assert_select 'form[action=?][method=?]', time_sheet_path(@time_sheet), 'post' do

    end
end
