require 'rails_helper'
require 'spec_helper'

RSpec.describe TimeSheetsController, type: :controller do
  before(:each) do
    @user = FactoryGirl.create(:user)
    login_with @user
    @project = FactoryGirl.create(:project)
    @contract = FactoryGirl.create(:contract, hiwi: @user, chair: @project.chair)
  end

  let(:valid_attributes) {
    {month: 1, year: 2015, 
     user: @user, contract: @contract}
  }

  let(:signature_valid_attributes) {
    {month: 1, year: 2015, 
     user: @user, contract: @contract, signed: 1}
  }

  let(:invalid_attributes) {
    {month: -1, year: 2015, 
      user: @user, contract: @contract}
  }

  let(:valid_session) { {} }

  describe 'GET #edit' do
    it 'assigns the requested time_sheet as @time_sheet' do
      time_sheet = TimeSheet.create! valid_attributes
      get :edit, {id: time_sheet.to_param}, valid_session
      expect(assigns(:time_sheet)).to eq(time_sheet)
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) {
        {month: 2, year: 2015, 
          user: @user, contract: @contract}
      }

      it 'updates the requested time_sheet' do
        time_sheet = TimeSheet.create! valid_attributes
        put :update, {id: time_sheet, time_sheet: new_attributes}, valid_session
        time_sheet.reload
        expect(time_sheet.month).to eq(2)
      end

      it 'redirects to the time sheet edit path' do
        time_sheet = TimeSheet.create! valid_attributes
        put :update, {id: time_sheet.to_param, time_sheet: valid_attributes}, valid_session
        expect(response).to redirect_to(edit_time_sheet_path(time_sheet))
      end
    end

    context 'with invalid params' do
      it 'assigns the time_sheet as @time_sheet' do
        time_sheet = TimeSheet.create! valid_attributes
        put :update, {id: time_sheet.to_param, time_sheet: invalid_attributes}, valid_session
        expect(assigns(:time_sheet)).to eq(time_sheet)
      end

      it "re-renders the 'edit' template" do
        time_sheet = TimeSheet.create! valid_attributes
        put :update, {id: time_sheet.to_param, time_sheet: invalid_attributes}, valid_session
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'GET #hand_in' do
    context 'with valid params' do
      it 'should not hand in time sheet if signature is absent' do
        request.env["HTTP_REFERER"] = ''
        time_sheet = TimeSheet.create! valid_attributes
        get :hand_in, {id: time_sheet.to_param, time_sheet: signature_valid_attributes}, valid_session

        expect(response).to have_http_status(302)
        expect(time_sheet.signed).to be false
        expect(flash.count).to eq(1)
      end

      it 'should hand in time sheet with signature if present' do
        @user.update(signature: 'Signature')
        time_sheet = TimeSheet.create! valid_attributes
        get :hand_in, {id: time_sheet.to_param, time_sheet: signature_valid_attributes}, valid_session
        # the controller action modifies the time_sheet
        time_sheet.reload
        expect(time_sheet.user_signature).to_not be_nil
        expect(time_sheet.signed).to be true
        expect(time_sheet.user_signed_at).to_not be_nil
      end

      it 'should trigger a notification on successful submission' do
        time_sheet = TimeSheet.create! valid_attributes
        expect {
          get :hand_in, {id: time_sheet.to_param, time_sheet: valid_attributes}, valid_session
        }.to change { EventTimeSheetSubmitted.count }.by(1)
      end
    end
  end
end
