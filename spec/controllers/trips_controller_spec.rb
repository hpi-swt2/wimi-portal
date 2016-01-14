require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

RSpec.describe TripsController, type: :controller do
  before(:each) do
    login_with create ( :user)
  end

  # This should return the minimal set of attributes required to create a valid
  # Trip. As you add validations to Trip, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    {destination: 'NYC Conference',
     reason: 'Hana Things',
     annotation: 'HANA pls',
     signature: true,
     user: FactoryGirl.create(:user)}
  }

  let(:invalid_attributes) {
    {
     destination: '',
     reason: 'Hana Things',
     annotation: 'HANA pls',
     signature: true,
     user: FactoryGirl.create(:user)}
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # TripsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe 'GET #index' do
    it 'assigns all trips as @trips' do
      trip = Trip.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:trips)).to eq(Trip.all)
    end
  end

  describe 'GET #show' do
    it 'assigns the requested trip as @trip' do
      trip = Trip.create! valid_attributes
      get :show, {id: trip.to_param}, valid_session
      expect(assigns(:trip)).to eq(trip)
    end
  end

  describe 'GET #new' do
    it 'assigns a new trip as @trip' do
      get :new, {}, valid_session
      expect(assigns(:trip)).to be_a_new(Trip)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested trip as @trip' do
      trip = Trip.create! valid_attributes
      get :edit, {id: trip.to_param}, valid_session
      expect(assigns(:trip)).to eq(trip)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Trip' do
        expect {
          post :create, {trip: valid_attributes}, valid_session
        }.to change(Trip, :count).by(1)
      end

      it 'assigns a newly created trip as @trip' do
        post :create, {trip: valid_attributes}, valid_session
        expect(assigns(:trip)).to be_a(Trip)
        expect(assigns(:trip)).to be_persisted
      end

      it 'redirects to the created trip' do
        post :create, {trip: valid_attributes}, valid_session
        expect(response).to redirect_to(Trip.last)
      end
      it "has the status saved" do
        trip = Trip.create! valid_attributes
        expect(trip.status).to eq('saved')
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved trip as @trip' do
        post :create, {trip: invalid_attributes}, valid_session
        expect(assigns(:trip)).to be_a_new(Trip)
      end

      it "re-renders the 'new' template" do
        post :create, {trip: invalid_attributes}, valid_session
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) {
        {
     destination: 'NYC',
     reason: 'Hana',
     annotation: 'HANA',
     signature: false,
     user: User.first}
      }

      it 'updates the requested trip' do
        trip = Trip.create! valid_attributes
        put :update, {id: trip.to_param, trip: new_attributes}, valid_session
        trip.reload
        expect(trip.destination).to eq('NYC')
        expect(trip.status).to eq('saved')
      end

      it 'assigns the requested trip as @trip' do
        trip = Trip.create! valid_attributes
        put :update, {id: trip.to_param, trip: valid_attributes}, valid_session
        expect(assigns(:trip)).to eq(trip)
      end

      it 'redirects to the trip' do
        trip = Trip.create! valid_attributes
        put :update, {id: trip.to_param, trip: valid_attributes}, valid_session
        expect(response).to redirect_to(trip)
      end
    end

    context 'with invalid params' do
      it 'assigns the trip as @trip' do
        trip = Trip.create! valid_attributes
        put :update, {id: trip.to_param, trip: invalid_attributes}, valid_session
        expect(assigns(:trip)).to eq(trip)
      end

      it "re-renders the 'edit' template" do
        trip = Trip.create! valid_attributes
        put :update, {id: trip.to_param, trip: invalid_attributes}, valid_session
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested trip' do
      trip = Trip.create! valid_attributes
      expect {
        delete :destroy, {id: trip.to_param}, valid_session
      }.to change(Trip, :count).by(-1)
    end

    it 'redirects to the trips list' do
      trip = Trip.create! valid_attributes
      delete :destroy, {id: trip.to_param}, valid_session
      expect(response).to redirect_to(trips_url)
    end

    it 'redirects to the trip, if it is already applied' do
      trip = Trip.create! valid_attributes
      trip.status = 'applied'
      trip.save
      get :edit, {id: trip.id}
      expect(response).to have_http_status(302)
      expect(response).to redirect_to(trip_path(trip))
    end

  end

  describe 'POST #hand_in' do
    it 'hands in a trip request' do
      user = FactoryGirl.create(:user)
      trip = Trip.create! valid_attributes
      trip.user = user
      
      login_with(user)
      post :hand_in, { id: trip.id }
    end
  end
end
