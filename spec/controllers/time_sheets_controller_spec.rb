require 'rails_helper'
require 'spec_helper'
require 'cancan/matchers'

RSpec.describe TimeSheetsController, type: :controller do
  before(:each) do
    @user = FactoryGirl.create(:user)
    login_with @user
    @project = FactoryGirl.create(:project)
    @contract = FactoryGirl.create(:contract, hiwi: @user, chair: @project.chair, start_date: Date.new(2015,1), end_date: Date.new(2016,1))
  end

  let(:valid_attributes) {
    {month: @contract.start_date.month, year: @contract.start_date.year,
     user: @user, contract: @contract}
  }
  let(:time_sheet) {
    TimeSheet.create! valid_attributes
  }
  let(:signature_valid_attributes) {
    {month: @contract.start_date.month, year: @contract.start_date.year,
     user: @user, contract: @contract, signed: 1}
  }
  let(:invalid_attributes) {
    {month: -1, year: @contract.start_date.year,
      user: @user, contract: @contract}
  }
  let(:valid_session) { {} }

  describe 'GET #edit' do
    it 'assigns the requested time_sheet as @time_sheet' do
      get :edit, {id: time_sheet.to_param}, valid_session
      expect(assigns(:time_sheet)).to eq(time_sheet)
    end
  end

  describe 'PUT #update' do
    let(:new_attributes) {
      {month: 2, year: 2015, user: @user, contract: @contract}
    }

    context 'with valid params' do
      it 'updates the requested time_sheet' do
        put :update, {id: time_sheet, time_sheet: new_attributes}, valid_session
        time_sheet.reload
        expect(time_sheet.month).to eq(2)
      end

      it 'redirects to the time sheet show path' do
        put :update, {id: time_sheet.to_param, time_sheet: valid_attributes}, valid_session
        expect(response).to redirect_to(time_sheet_path(time_sheet))
      end
    end

    context 'with invalid params' do
      it 'assigns the time_sheet as @time_sheet' do
        put :update, {id: time_sheet.to_param, time_sheet: invalid_attributes}, valid_session
        expect(assigns(:time_sheet)).to eq(time_sheet)
      end

      it "re-renders the 'edit' template" do
        put :update, {id: time_sheet.to_param, time_sheet: invalid_attributes}, valid_session
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'GET #hand_in' do
    context 'with valid params' do
      it 'should not hand in time sheet if signature should be added, but isn\'t available in profile' do
        request.env["HTTP_REFERER"] = ''
        get :hand_in, {id: time_sheet.to_param, time_sheet: signature_valid_attributes}, valid_session
        expect(response).to have_http_status(302)
        expect(time_sheet.signed).to be false
        expect(flash.count).to eq(1)
      end

      it 'should hand in time sheet with signature if present' do
        @user.update(signature: 'Signature')
        get :hand_in, {id: time_sheet.to_param, time_sheet: signature_valid_attributes}, valid_session
        # the controller action modifies the time_sheet
        time_sheet.reload
        expect(time_sheet.user_signature).to_not be_nil
        expect(time_sheet.signed).to be true
        expect(time_sheet.user_signed_at).to_not be_nil
      end

      it 'should trigger a notification on successful submission' do
        expect {
          get :hand_in, {id: time_sheet.to_param, time_sheet: valid_attributes}, valid_session
        }.to change { EventTimeSheetSubmitted.count }.by(1)
      end

      it 'should not update attributes on hand_in if already handed in' do
        time_sheet.hand_in()
        expect {
          get :hand_in, {id: time_sheet.to_param, time_sheet: valid_attributes}, valid_session
        }.to_not change { time_sheet.hand_in_date }
        expect(flash.count).to eq(1)
      end
    end
  end

  describe 'download' do
    it 'is allowed when the user can show the timesheet' do
      expect(Ability.new @user).to be_able_to(:show, time_sheet)
      get :download, {id: time_sheet}
      expect(response).to redirect_to(generate_pdf_path(doc_type: 'Timesheet', doc_id: time_sheet))
    end

    it 'is not allowed when the user cannot show the timesheet' do
      other_contract = FactoryGirl.create(:contract)
      time_sheet = FactoryGirl.create(:time_sheet, contract: other_contract)
      expect(Ability.new @user).to_not be_able_to(:show, time_sheet)
      get :download, {id: time_sheet}
      expect(flash.count).to eq(1)
    end
  end
end
