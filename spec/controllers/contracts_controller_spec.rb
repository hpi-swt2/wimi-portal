require 'rails_helper'
require 'spec_helper'
require 'cancan/matchers'

RSpec.describe ContractsController, type: :controller do
  before(:each) do
    @hiwi = FactoryGirl.create(:user)
    @contract = FactoryGirl.create(:contract, hiwi: @hiwi)
    @wimi = @contract.responsible
  end

  let(:valid_attributes) {
    FactoryGirl.attributes_for(:contract, responsible: @wimi, hiwi: @hiwi)
  }

  let(:invalid_attributes) {
    FactoryGirl.attributes_for(:contract,
      responsible: @wimi,
      hiwi: @hiwi,
      start_date: nil,
      end_date: nil
    )
  }

  describe 'a hiwi' do
    before :each do
      login_with @hiwi
    end

    context 'cannot access' do
      it '#create' do
        post :create, {contract: valid_attributes}
      end

      it '#update' do
        put :update, {id: @contract.id, contract: {end_date: Date.today >> 1}}
      end

      after :each do
        expect(flash[:success]).to be_nil
        expect(flash[:error]).not_to be_nil
        expect(response).to redirect_to(contracts_path)
      end
    end
  end

  describe 'POST #create' do
    before :each do
      login_with @wimi
    end

    context 'with invalid params' do
      it 'renders #new' do
        post :create, {contract: invalid_attributes}
        expect(response).to render_template(:new)
        expect(flash[:success]).to be_nil
      end
    end
  end

  describe 'get #index' do
    context 'as a hiwi with one contract' do
      it 'redirects to #show' do
        login_with @hiwi
        get :index
        expect(response).to redirect_to(contract_path(@contract))
      end
    end

    context 'as a wimi' do
      it 'renders #index' do
        login_with @wimi
        get :index
        expect(response).to render_template(:index)
      end
    end
  end

  describe 'put #update' do
    context 'with invalid params' do
      it 'renders #edit' do
        login_with @wimi
        put :update, {id: @contract.id, contract: invalid_attributes}
        expect(response).to render_template(:edit)
        expect(flash[:success]).to be_nil
      end
    end
  end

  describe 'delete #destroy' do
    context 'as a hiwi' do
      it 'is not allowed' do
        login_with @hiwi
        delete :destroy, {id: @contract.id}
        expect(response).to redirect_to(contracts_path)
        expect(flash[:success]).to be_nil
        expect(flash[:error]).not_to be_nil
      end
    end

    context 'as a wimi' do
      it 'deletes the contract' do
        login_with @wimi
        expect {
          delete :destroy, {id: @contract.id}
        }.to change(Contract, :count).by -1
        expect(response).to redirect_to(contracts_path)
        expect(flash[:success]).not_to be_nil
        expect(flash[:error]).to be_nil
      end
    end
  end
end