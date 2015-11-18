require 'rails_helper'

RSpec.describe "chairs/edit", type: :view do
  before(:each) do
    @chair = assign(:chair, Chair.create!(
      :name => "MyString"
    ))
  end

  it "renders the edit chair form" do
    render

    assert_select "form[action=?][method=?]", chair_path(@chair), "post" do

      assert_select "input#chair_name[name=?]", "chair[name]"
    end
  end
end
