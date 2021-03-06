require 'rails_helper'

# expenses currently out of order
RSpec.describe ExpensesController, type: :controller do
#  before(:each) do
#    wimi = FactoryGirl.create(:wimi, chair: FactoryGirl.create(:chair))
#    @user = wimi.user
#    @trip = FactoryGirl.create(:trip)
#    login_with (@user)
#  end
#
#  # This should return the minimal set of attributes required to create a valid
#  # Expense. As you add validations to Expense, be sure to
#  # adjust the attributes here as well.
#  let(:valid_attributes) {
#    {inland: true,
#     country: 'Germany',
#     location_from: 'Potsdam',
#     location_via: 'London',
#     time_start: '12:00',
#     time_end: '23:00',
#     reason: 'Hana Things',
#     car: true,
#     public_transport: true,
#     vehicle_advance: false,
#     hotel: true,
#     general_advance: 2000,
#     signature: 1,
#     user: @user,
#     trip: @trip}
#  }
#
#  let(:advance_blank_attributes) {
#    {inland: true,
#     country: 'Germany',
#     location_from: 'Potsdam',
#     location_via: 'London',
#     time_start: '12:00',
#     time_end: '23:00',
#     reason: 'Hana Things',
#     car: true,
#     public_transport: true,
#     vehicle_advance: false,
#     hotel: true,
#     general_advance: '',
#     signature: 1,
#     user: @user,
#     trip: @trip}
#  }
#
#  let(:invalid_attributes) {
#    {inland: true,
#     country: 'Germany',
#     location_from: 'Potsdam',
#     location_via: 'London',
#     time_start: '1asda2:00',
#     time_end: '2312:123100',
#     reason: 'Hana Things',
#     car: true,
#     public_transport: true,
#     vehicle_advance: false,
#     hotel: true,
#     general_advance: -100,
#     signature: 1,
#     user: @user,
#     trip: @trip}
#  }
#
#  # This should return the minimal set of values that should be in the session
#  # in order to pass any filters (e.g. authentication) defined in
#  # ExpensesController. Be sure to keep this updated too.
#  let(:valid_session) { {} }
#
#  describe 'GET #new' do
#    it 'assigns a new expense as @expense' do
#      get :new, {trip_id: @trip.id}, valid_session
#      expect(assigns(:expense)).to be_a_new(Expense)
#    end
#  end
#
#  describe 'GET #edit' do
#    it 'assigns the requested expense as @expense' do
#      expense = Expense.create! valid_attributes
#      get :edit, {trip_id: @trip.id, id: expense.to_param}, valid_session
#      expect(assigns(:expense)).to eq(expense)
#    end
#
#    it 'redirects to the corresponding trip, if it is already applied' do
#      expense = Expense.create! valid_attributes
#      expense.update_attributes(status: 'applied')
#      get :edit, {trip_id: @trip.id, id: expense.id}
#      expect(response).to have_http_status(302)
#      expect(response).to redirect_to(@trip)
#    end
#  end
#
#  describe 'POST #create' do
#    context 'with valid params' do
#      it 'creates a new Expense' do
#        expect {
#          post :create, {trip_id: @trip.id, expense: valid_attributes}, valid_session
#        }.to change(Expense, :count).by(1)
#      end
#
#      it 'should add signature to expense if signature was found' do
#        @user.signature = 'Signature'
#        expect {
#          post :create, {trip_id: @trip.id,expense: valid_attributes}, valid_session
#        }.to change(Expense, :count).by(1)
#        expect(Expense.last.signature).to eq(true)
#      end
#
#      it 'assigns a newly created expense as @expense' do
#        post :create, {trip_id: @trip.id, expense: valid_attributes}, valid_session
#        expect(assigns(:expense)).to be_a(Expense)
#        expect(assigns(:expense)).to be_persisted
#      end
#
#      it 'redirects to the corresponding trip' do
#        post :create, {trip_id: @trip.id, expense: valid_attributes}, valid_session
#        expect(response).to redirect_to(@trip)
#      end
#    end
#
#    context 'with invalid params' do
#      it 'assigns a newly created but unsaved expense as @expense' do
#        post :create, {trip_id: @trip.id, expense: invalid_attributes}, valid_session
#        expect(assigns(:expense)).to be_a_new(Expense)
#      end
#
#      it "re-renders the 'new' template" do
#        post :create, {trip_id: @trip.id, expense: invalid_attributes}, valid_session
#        expect(response).to render_template('new')
#      end
#      it 'rejects blank values for advance' do
#        post :create, {trip_id: @trip.id, expense: advance_blank_attributes}, valid_session
#        expect(response).to render_template('new')
#      end
#    end
#  end
#
#
#  describe 'PUT #update' do
#    context 'with valid params' do
#      let(:new_attributes) {
#        valid_attributes[:first_name] = 'Tobias'
#        valid_attributes
#      }
#      let(:valid_attributes_without_signature) {
#        valid_attributes[:signature] = false
#        valid_attributes
#      }
#
#      it 'updates the requested expense' do
#        expense = Expense.create! valid_attributes
#        put :update, {trip_id: @trip.id, id: expense.to_param, expense: new_attributes}, valid_session
#        expense.reload
#        expect(assigns(:expense)).to eq(expense)
#      end
#      
#      it 'should add signature to expense if signature was found' do
#        @user.signature = 'Signature'
#        expense = Expense.create! valid_attributes
#        expect {
#          put :update, {trip_id: @trip.id,id: expense.to_param, expense: new_attributes}, valid_session
#        }.to change(Expense, :count).by(0)
#        expect(Expense.last.signature).to eq(true)
#      end
#      
#      it 'should set signature to nil if signature was absent' do
#        @user.signature = nil
#        expense = Expense.create! valid_attributes
#        expect {
#          put :update, {trip_id: @trip.id,id: expense.to_param, expense: new_attributes}, valid_session
#        }.to change(Expense, :count).by(0)
#        expect(Expense.last.user_signature).to eq(nil)
#        expect(Expense.last.user_signed_at).to eq(nil)
#      end
#      
#      it 'should set signature and date to nil if signature should not be added' do
#        
#        expense = Expense.create! valid_attributes
#        expect {
#          put :update, {trip_id: @trip.id,id: expense.to_param, expense: valid_attributes_without_signature}, valid_session
#        }.to change(Expense, :count).by(0)
#        expect(Expense.last.user_signature).to eq(nil)
#        expect(Expense.last.user_signed_at).to eq(nil)
#      end
#
#      it 'assigns the requested expense as @expense' do
#        expense = Expense.create! valid_attributes
#        put :update, {trip_id: @trip.id, id: expense.to_param, expense: valid_attributes}, valid_session
#        expect(assigns(:expense)).to eq(expense)
#      end
#
#      it 'redirects to the corresponding trip' do
#        expense = Expense.create! valid_attributes
#        put :update, {trip_id: @trip.id, id: expense.to_param, expense: valid_attributes}, valid_session
#        expect(response).to redirect_to(@trip)
#      end
#
#    end
#
#    context 'with invalid params' do
#      it 'assigns the expense as @expense' do
#        expense = Expense.create! valid_attributes
#        put :update, {trip_id: @trip.id, id: expense.to_param, expense: invalid_attributes}, valid_session
#        expect(assigns(:expense)).to eq(expense)
#      end
#
#      it "re-renders the 'edit' template" do
#        expense = Expense.create! valid_attributes
#        put :update, {trip_id: @trip.id, id: expense.to_param, expense: invalid_attributes}, valid_session
#        expect(response).to render_template('edit')
#      end
#    end
#  end
#
#  describe 'DELETE #destroy' do
#    it 'destroys the requested expense' do
#      expense = Expense.create! valid_attributes
#      expect {
#        delete :destroy, {trip_id: @trip.id, id: expense.to_param}, valid_session
#      }.to change(Expense, :count).by(-1)
#    end
#
#    it 'redirects to the corresponding trip' do
#      expense = Expense.create! valid_attributes
#      delete :destroy, {trip_id: @trip.id, id: expense.to_param}, valid_session
#      expect(response).to redirect_to(@trip)
#    end
#
#    it 'can not destroy applied expenses' do
#      expense = Expense.create! valid_attributes
#      expense.trip.update(status: 'accepted')
#      expense.user = @user
#      login_with(@user)
#      post :hand_in, {id: expense.id}
#      expect {
#        delete :destroy, {trip_id: @trip.id, id: expense.to_param}, valid_session
#      }.to change(Expense, :count).by(0)
#    end
#  end
#
#  describe 'POST #hand_in' do
#    it 'hands in a expense request' do
#      expense = Expense.create! valid_attributes
#      expense.trip.update(status: 'accepted')
#      expense.user = @user
#      login_with(@user)
#      post :hand_in, {id: expense.id}
#      expect(Expense.find(expense.id).status).to eq('applied')
#    end
#
#    it 'normal user can not hand in a expense request' do
#      user = FactoryGirl.create(:user)
#      expense = Expense.create! valid_attributes
#      expense.user = user
#      login_with(user)
#      post :hand_in, {id: expense.id}
#      expect(Expense.find(expense.id).status).to eq('saved')
#    end
#  end
end
