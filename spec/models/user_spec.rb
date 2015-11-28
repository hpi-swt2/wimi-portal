require 'rails_helper'

RSpec.describe User, type: :model do
  it "has a valid factory" do
  	expect(FactoryGirl.create(:user)).to be_valid
  end
  
  it "returns the full name of the user" do
    @user = FactoryGirl.create(:user)
    expect(@user.name).to eq('John Doe')
  end

  it "splits fullname into first and last name" do
  	@user = FactoryGirl.create(:user, first: nil, last_name: nil, name: 'Jane Smith')
  	expect(@user.first).to eq('Jane')
  	expect(@user.last_name).to eq('Smith')
  end
end
