require 'rails_helper'
require 'spec_helper'
require 'cancan/matchers'

RSpec.describe ContractsController, type: :controller do
  before(:each) do
    @user = FactoryGirl.create(:user)
    login_with @user
    @contract = FactoryGirl.create(:contract, hiwi: @user)
  end
end