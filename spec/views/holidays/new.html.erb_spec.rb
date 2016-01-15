require 'rails_helper'

RSpec.describe 'holidays/new', type: :view do
  before(:each) do
    assign(:holiday, Holiday.new)
  end

  it 'renders new holiday form' do
    render

    assert_select 'form[action=?][method=?]', holidays_path, 'post' do
    end
  end
end
