require 'rails_helper'

RSpec.describe "chairs/new", type: :view do
  before(:each) do
    @user = FactoryGirl.create(:user)
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

  xit "creates a new chair with admin and representatives" do

    admin = FactoryGirl.create(:user, :first => "TestAdmin")
    representative = FactoryGirl.create(:user, :first => "TestRepresentative")

    login_as(@user, :scope => :user)
    visit(new_chair_path)
    fill_in('Name', :with => 'TestChair')
    expect(User.all.size).to eq(3)
    expect(page).to have_select("admin_user")
    # expect(page).to have_select("admin_user", options: ["Please select", @user.name, admin.name, representative.name])
    select(admin.name, :from => 'admin_user')
    select(representative.first, :from => "representative_user")
    submit_form

    expect(current_path).to eq(chairs_path)
    expect(page).to have_text("TestChair")
    expect(Chair.all.size).to eq(1)
    expect(Chair.last.admins.size).to eq(1)
    expect(Chair.last.representatives.size).to eq(1)

  end
end
