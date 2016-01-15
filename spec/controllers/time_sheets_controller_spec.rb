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
      workload: 100, workload_is_per_month: true, user_id: @user.id,
      project_id: @project.id}
  }

  let(:invalid_attributes) {
    {month: 1, year: 2015, salary: -100, salary_is_per_month: false,
      workload: 100, workload_is_per_month: nil, user_id: @user.id,
      project_id: @project.id}
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
          workload: 200, workload_is_per_month: true, user_id: @user.id,
          project_id: @project.id}
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
end
