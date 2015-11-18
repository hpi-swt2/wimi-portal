require 'rails_helper'

RSpec.describe "chairs/new", type: :view do
  before(:each) do
    assign(:chair, Chair.new(
      :name => "MyString"
    ))
  end

  it "renders new chair form" do
    render

    assert_select "form[action=?][method=?]", chairs_path, "post" do

      assert_select "input#chair_name[name=?]", "chair[name]"
    end
  end
end
