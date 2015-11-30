require 'rails_helper'

RSpec.describe UsersController, type: :controller do
=begin
  before(:each) do
    login_with create ( :user)
  end
=end

  let(:valid_attributes) {
    { password: '12345678', email: 'person@example.com', number: '1' }
  }
  let(:valid_attributes2) {
    { password: '12345678', email: 'person2@example.com', number: '2' }
  }

  let(:invalid_attributes) {
    { password: '87654321', email: 'person2@example.com', number: 'a' }
  }

  let(:valid_session) { {} }

  describe "GET #show" do
    it "shows my page" do
      user = User.create! valid_attributes
      login_with user
      get :show, {:id => user.to_param}
      expect(assigns(:user)).to eq(user)
    end
    it "redirects me to the root_path if i try to access someone elses page" do
      user1 = User.create! valid_attributes
      user2 = User.create! valid_attributes2
      login_with user2
      get :show, {:id => user1.to_param}
      expect(response).to redirect_to(root_path)
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        { password: '87654321', email: 'person2@example.com', number: '2' }
      }

      it "updates the requested user" do
        user = User.create! valid_attributes
        login_with user
        put :update, {:id => user.to_param, :user => new_attributes}
        user.reload
        expect(assigns(:user)).to eq(user)
      end

      it "redirects to the user" do
        user = User.create! valid_attributes
        login_with user
        put :update, {:id => user.to_param, :user => new_attributes}
        expect(response).to redirect_to(user)
      end

    end

    context "with invalid params" do
      it "assigns the user as @user" do
        user = User.create! valid_attributes
        login_with user
        put :update, {:id => user.to_param, :user => invalid_attributes}
        expect(assigns(:user)).to eq(user)
      end

      it "redirects to the edit page" do
        user = User.create! valid_attributes
        login_with user
        put :update, {:id => user.to_param, :user => invalid_attributes}
        expect(response).to redirect_to(edit_user_path)
      end
    end
  end

end
