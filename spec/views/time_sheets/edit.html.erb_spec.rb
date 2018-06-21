require 'rails_helper'

RSpec.describe 'time_sheets/edit', type: :view do
  before(:each) do
    @time_sheet = assign(:time_sheet, FactoryBot.create(:time_sheet))
    login_as @time_sheet.contract.hiwi
  end

  it 'renders the edit time_sheet form' do
    render

    assert_select 'form[action=?][method=?]', time_sheet_path(@time_sheet), 'post' do

    end
  end
end
