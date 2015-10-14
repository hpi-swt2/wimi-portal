require 'rails_helper'

RSpec.describe 'holidays/index', type: :view do
  before(:each) do
    assign(:holidays, [
      Holiday.create!,
      Holiday.create!
    ])
  end

  it 'renders a list of holidays' do
    render
  end
end
