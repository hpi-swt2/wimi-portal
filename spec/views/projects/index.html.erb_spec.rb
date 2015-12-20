require 'rails_helper'

RSpec.describe 'projects/index', type: :view do
  before(:each) do
    @user = FactoryGirl.create(:user)
    login_as @user

  end

end