require 'rails_helper'

RSpec.describe "chairs/index", type: :view do
  before(:each) do
    assign(:chairs, [
      Chair.create!,
      Chair.create!
    ])
  end

  xit "renders a list of chairs" do
    render
  end
end
