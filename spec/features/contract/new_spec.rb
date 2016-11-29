require 'rails_helper'

describe 'A user' do
  before :each do
    @hiwi = FactoryGirl.create(:hiwi)
    @wimi = FactoryGirl.create(:wimi).user
    @contract = FactoryGirl.create(:contract, hiwi: @hiwi, responsible: @wimi)
  end

  context "can have multiple contracts" do
    it 'shows contracts#index for a WiMi (as it includes the New button)' do
      @contract2 = FactoryGirl.create(:contract, hiwi: @hiwi, responsible: @wimi)

      expect(@hiwi.contracts.size).to eq(2)
    end
  end
end