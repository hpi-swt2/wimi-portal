require 'rails_helper'
require 'spec_helper'

RSpec.describe ContractsController, type: :controller do
  before(:each) do
    @user = FactoryGirl.create(:user)
    login_with @user
    @project = FactoryGirl.create(:project)
    @contract = FactoryGirl.create(:contract, hiwi: @user, chair: @project.chair, start_date: Date.new(2015,1), end_date: Date.new(2016,1))
    @user_ability = Ability.new(@user)
  end

  describe 'GET #dismiss' do
    it 'dismisses a month for a contract for the current user' do
      expect(DismissedMissingTimesheet.dates_for(@user,@contract).size).to eq(0)
      expect(@user_ability.can? :show, @contract).to be true

      get :dismiss, {id: @contract.id, month: @contract.start_date.at_beginning_of_month}
      
      expect(flash[:success]).not_to be nil
      expect(DismissedMissingTimesheet.dates_for(@user,@contract).size).to eq(1)
    end
  end
end