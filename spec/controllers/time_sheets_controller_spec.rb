require 'rails_helper'
require 'spec_helper'

RSpec.describe TimeSheetsController, type: :controller do
  before(:each) do
    @user = FactoryGirl.create(:user)
    login_with @user
    @project = FactoryGirl.create(:project)
  end

  let(:valid_attributes) {
    {month: 1, year: 2015, salary: 100, salary_is_per_month: true,
     workload: 100, workload_is_per_month: true, user: @user,
     project: @project}
  }

  let(:signature_valid_attributes) {
    {month: 1, year: 2015, salary: 100, salary_is_per_month: true,
     workload: 100, workload_is_per_month: true, user: @user,
     project: @project, signed: 1}
  }

  let(:invalid_attributes) {
    {month: 1, year: 2015, salary: -100, salary_is_per_month: false,
     workload: 100, workload_is_per_month: nil, user: @user,
     project: @project}
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
        {month: 1, year: 2015, salary: 100, salary_is_per_month: false,
         workload: 200, workload_is_per_month: true, user: @user,
         project: @project}
      }

      it 'updates the requested time_sheet' do
        time_sheet = TimeSheet.create! valid_attributes
        put :update, {id: time_sheet.to_param, time_sheet: new_attributes}, valid_session
        time_sheet.reload
        expect(time_sheet.workload).to eq(200)
      end

      it 'assigns the requested time_sheet as @time_sheet' do
        time_sheet = TimeSheet.create! valid_attributes
        put :update, {id: time_sheet.to_param, time_sheet: valid_attributes}, valid_session
        expect(assigns(:time_sheet)).to eq(time_sheet)
      end

      it 'redirects to the time_sheet' do
        time_sheet = TimeSheet.create! valid_attributes
        put :update, {id: time_sheet.to_param, time_sheet: valid_attributes}, valid_session
        expect(response).to redirect_to(work_days_path(month: time_sheet.month, year: time_sheet.year, project: time_sheet.project))
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
        expect(time_sheet.signed).to eq(false)
        assert_equal 'The document was not handed in, because you have selected to sign the document, but there was no signature found', flash[:error]
      end

      it 'should hand in time sheet with signature if present' do
        @user.update(signature: 'Signature')
        time_sheet = TimeSheet.create! valid_attributes
        get :hand_in, {id: time_sheet.to_param, time_sheet: signature_valid_attributes}, valid_session

        expect(TimeSheet.find_by(time_sheet.id).user_signature).to_not eq(nil)
        expect(TimeSheet.find_by(time_sheet.id).signed).to eq(true)
        expect(TimeSheet.find_by(time_sheet.id).user_signed_at).to_not eq(nil)
      end
    end
  end
end
