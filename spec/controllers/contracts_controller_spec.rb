require 'rails_helper'
require 'spec_helper'
require 'cancan/matchers'

RSpec.describe ContractsController, type: :controller do
  before(:each) do
    @user = FactoryGirl.create(:user)
    login_with @user
    @contract = FactoryGirl.create(:contract, hiwi: @user)
  end

  describe 'GET #dismiss' do
    it 'dismisses a month for a contract for the current user' do
      expect(DismissedMissingTimesheet.dates_for(@user, @contract).size).to eq(0)
      expect(Ability.new @user).to be_able_to(:show, @contract)

      get :dismiss, {id: @contract.id, month: @contract.start_date.at_beginning_of_month}
      
      expect(flash[:success]).not_to be nil
      expect(flash[:error]).to be nil
      expect(DismissedMissingTimesheet.dates_for(@user, @contract).size).to eq(1)
    end
  end
end