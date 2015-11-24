require 'rails_helper'

RSpec.describe UserProfileController, type: :controller do

  before(:each) do
    @current_user = FactoryGirl.create(:user)
    login_with @current_user
  end

  let(:valid_attributes) {
    { first: 'Bob', last_name: 'Smith', email: 'Email' }
  }

  let(:invalid_attributes) {
    { first: 'Bob', last_name: 'Smith', email: nil }
  }

  let(:valid_session) { {} }

  describe 'PUT #update' do
      context 'with valid params' do
        let(:new_attributes) {
          { first: 'Bob', last_name: 'Smith', email: 'new email' }
        }

        it 'updates the current user' do
          put :update, {id: @current_user.to_param, user: new_attributes}, valid_session
          @current_user.reload
          expect(@current_user.email).to eq('new email')
        end

      context 'with invalid params' do
        it 'doesnt update the user' do
          user = @current_user
          put :update, {id: @current_user.to_param, user: invalid_attributes}, valid_session
          expect(@current_user).to eq(user)
        end
      end
    end
  end
end