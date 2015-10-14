require 'rails_helper'

RSpec.describe 'holidays/show', type: :view do
  before(:each) do
    @holiday = assign(:holiday, Holiday.create!)
  end

  it 'renders attributes in <p>' do
    render
  end
end
