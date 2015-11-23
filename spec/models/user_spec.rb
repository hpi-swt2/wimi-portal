require 'rails_helper'

RSpec.describe User, type: :model do
  it "has a valid factory" do
  	FactoryGirl.create(:user).should be_valid
  end
  
  it "returns the full name of the user" do
    @user = FactoryGirl.create(:user)
    @user.name.should eq('John Doe')
  end

  it "splits fullname into first and last name" do
  	@user = FactoryGirl.create(:user, first: nil, last_name: nil, name: 'Jane Smith')
  	@user.first.should eq('Jane')
  	@user.last_name.should eq('Smith')
  end
end
