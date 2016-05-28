require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:valid_attributes) {
    {first_name: 'John', last_name: 'Doe', email: 'person@example.com', personnel_number: '1'}
  }

  let(:invalid_attributes) {
    {email: 'person2example.com', personnel_number: 'a'}
  }
  let(:invalid_attributes2) {
    {email: 'person@example.com', personnel_number: '9999999999'}
  }
  let(:invalid_attributes3) {
    {email: 'person@example.com', personnel_number: '-1'}
  }

  let(:valid_session) { {} }

  describe 'GET #show' do
    it 'shows the users profile page' do
      user = User.create! valid_attributes
      login_with user
      get :show, {id: user.to_param}
      expect(assigns(:user)).to eq(user)
    end

    # TODO: figure out what to do
#    context 'without existing user' do
#      it 'shows error page' do
#        user = User.create! valid_attributes
#        login_with user
#        get :show, {id: -1}
#        
#        expect(response).to_not have_http_status(:success)
#      end
#    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) {
        {email: 'person2@example.com'}
      }

      it 'updates the requested user' do
        user = User.create! valid_attributes
        login_with user
        put :update, {id: user.to_param, user: new_attributes}
        user.reload
        expect(assigns(:user)).to eq(user)
      end

      it 'redirects to the user' do
        user = User.create! valid_attributes
        login_with user
        put :update, {id: user.to_param, user: new_attributes}
        expect(response).to redirect_to(user)
      end
    end

    context 'with invalid params' do
      it 'assigns the user as @user' do
        user = User.create! valid_attributes
        login_with user
        put :update, {id: user.to_param, user: invalid_attributes}
        expect(assigns(:user)).to eq(user)
      end

      it 're-renders the edit page if the personnel_number is no number' do
        user = User.create! valid_attributes
        login_with user
        put :update, {id: user.to_param, user: invalid_attributes}
        expect(subject).to render_template(:edit)
      end

      it 're-renders the edit page if the personnel_number is too large' do
        user = User.create! valid_attributes
        login_with user
        put :update, {id: user.to_param, user: invalid_attributes2}
        expect(subject).to render_template(:edit)
      end

      it 're-renders the edit page if the personnel_number is too small' do
        user = User.create! valid_attributes
        login_with user
        put :update, {id: user.to_param, user: invalid_attributes3}
        expect(subject).to render_template(:edit)
      end
    end
  end

  describe 'POST #upload_signature' do
    before(:each) do
      @user = FactoryGirl.create(:user)

      login_with @user
    end

    context 'with valid file extension' do
      it 'uploads a signature' do
        file = fixture_file_upload('files/signature.png')
        @file = {}
        @file['datafile'] = file

        post :upload_signature, {id: @user.id, upload: @file}
        @user.reload

        expect(flash[:success]).to eq('Signature was successfully uploaded')
        expect(@user.signature).not_to be_nil
      end
    end

    context 'with invalid file extension' do
      it 'rejects the signature' do
        file = fixture_file_upload('files/signature.invalid')
        @file = {}
        @file['datafile'] = file

        post :upload_signature, {id: @user.id, upload: @file}
        @user.reload

        expect(flash[:error]).to eq('Please choose a file with a correct extension')
        expect(@user.signature).to be_nil
      end
    end
  end

  describe 'POST #delete_signature' do
    before(:each) do
      @user = FactoryGirl.create(:user, signature: 'test')
      login_with @user
    end

    it 'deletes the users signature' do
      post :delete_signature, {id: @user.id}
      @user.reload

      expect(flash[:success]).to eq('Signature successfully deleted')
      expect(@user.signature).to be_nil
    end
  end
end
