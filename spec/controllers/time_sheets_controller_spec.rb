require 'rails_helper'
require 'spec_helper'
require 'cancan/matchers'

RSpec.describe TimeSheetsController, type: :controller do
  before(:each) do
    @user = FactoryBot.create(:user)
    login_with @user
    @project = FactoryBot.create(:project)
    @chair = @project.chair
    @contract = FactoryBot.create(:contract, hiwi: @user, chair: @chair, start_date: Date.new(2015,1), end_date: Date.new(2016,1))
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
        expect(time_sheet.month).to eq(new_attributes[:month])
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
        expect(time_sheet.user_signature).to eq(@user.signature)
        expect(time_sheet.signed).to be true
        expect(time_sheet.user_signed_at).to eq(Date.today())
      end

      it 'should trigger a notification on successful submission' do
        expect {
          get :hand_in, {id: time_sheet.to_param, time_sheet: valid_attributes}, valid_session
        }.to change { Event.count }.by(1)
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

  describe 'GET #accept_reject' do
    before(:each) do
      time_sheet.hand_in()
      login_with @contract.responsible
    end

    context 'accept' do
      it 'should update attributes on accept' do
        expect {
          get :accept_reject, {id: time_sheet.to_param, time_sheet_action: 'accept', time_sheet: {}}
          time_sheet.reload
        }.to change { time_sheet.representative_signed_at }.from(nil).to(Date.today())
        expect(time_sheet.status).to eq('accepted')
        expect(flash.count).to eq(1)
        expect(flash[:success]).to_not be_nil
        expect(flash[:error]).to be_nil
      end

      it 'should not update attributes on accept if already accepted' do
        time_sheet.accept_as(@contract.responsible)
        time_sheet.update(representative_signed_at: @contract.start_date)
        expect {
          get :accept_reject, {id: time_sheet.to_param, time_sheet_action: 'accept', time_sheet: {}}
        }.to_not change { time_sheet.representative_signed_at }
        expect(time_sheet.representative_signed_at).to_not eq(Date.today())
      end
    end

    context 'reject' do
      let(:reject_params){
        {rejection_message: 'rejection!'}
      }

      it 'should update attributes on reject' do
        expect {
          get :accept_reject, {id: time_sheet.to_param, time_sheet_action: 'reject', time_sheet: reject_params}
          time_sheet.reload
        }.to change { time_sheet.status }.from('pending').to('rejected')
        expect(time_sheet.last_modified).to eq(Date.today())
        expect(time_sheet.rejection_message).to eq(reject_params[:rejection_message])
        expect(time_sheet.handed_in).to be false
        expect(flash.count).to eq(1)
        expect(flash[:success]).to_not be_nil
        expect(flash[:error]).to be_nil
      end

      it 'should not update attributes on reject if already rejected' do
        time_sheet.reject_as(@contract.responsible)
        time_sheet.update(last_modified: @contract.start_date)
        time_sheet.update(rejection_message: 'another message')
        expect {
          get :accept_reject, {id: time_sheet.to_param, time_sheet_action: 'reject', time_sheet: reject_params}
        }.to_not change { time_sheet.last_modified }
        expect(time_sheet.rejection_message).to_not eq(reject_params[:rejection_message])
        expect(time_sheet.last_modified).to_not eq(Date.today())
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
      other_contract = FactoryBot.create(:contract)
      time_sheet = FactoryBot.create(:time_sheet, contract: other_contract)
      expect(Ability.new @user).to_not be_able_to(:show, time_sheet)
      get :download, {id: time_sheet}
      expect(flash.count).to eq(1)
    end
  end

  describe 'current' do
    before :each do
      @contract = FactoryBot.create(:contract, hiwi: @user, chair: @project.chair, start_date: Date.today, end_date: Date.today >> 1)
    end

    context 'without a timesheet' do
      it 'redirects to new timesheet if user has valid contract' do
        get :current

        expect(TimeSheet.count).to eq(1)
        expect(response).to redirect_to(edit_time_sheet_path(TimeSheet.last))
      end

      it 'redirects to dashboard if user does not have valid contract' do
        @contract.destroy

        get :current

        expect(response).to redirect_to(dashboard_path)
        expect(flash[:error]).to eq(I18n.t('time_sheet.no_contract'))
      end
    end

    context 'with a timesheet' do
      it 'redirects to timesheet#edit if timesheet is not handed in' do
        @time_sheet = FactoryBot.create(:time_sheet, contract: @contract)

        get :current

        expect(response).to redirect_to(edit_time_sheet_path(@time_sheet))
      end

      it 'redirects to timesheet#show if timesheet is accepted' do
        @time_sheet = FactoryBot.create(:time_sheet_accepted, contract: @contract)

        get :current

        expect(response).to redirect_to(time_sheet_path(@time_sheet))
      end
    end
  end

  describe '#send_to_secretary' do
    before :each do
      @secretary = FactoryBot.create(:user)
      @wimi = @contract.responsible
      @timesheet = FactoryBot.create(:time_sheet_accepted, contract: @contract, year: @contract.start_date.year, month: @contract.start_date.month)
      FactoryBot.create(:secretary, chair: @chair, user: @secretary)
      login_with @wimi
    end
    context 'with an accepted timesheet' do
      it 'should send a mail to the secretary' do
        expect(Ability.new @wimi).to be_able_to(:send_to_secretary, @timesheet)
        expect{ get :send_to_secretary, {id: @timesheet.id} }.to change(ActionMailer::Base.deliveries, :count).by(1)
        expect(response).to redirect_to(time_sheet_path(@timesheet))
      end
    end
  end
end
