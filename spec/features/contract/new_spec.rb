require 'rails_helper'

describe 'A user' do
  before :each do
    @wimi = FactoryGirl.create(:wimi).user
    @hiwi = FactoryGirl.create(:hiwi, responsible: @wimi)    
    @contract = @hiwi.contracts.first
  end

  context "can have multiple contracts" do
    it 'shows contracts#index for a WiMi (as it includes the New button)' do
      @contract2 = FactoryGirl.create(:contract, hiwi: @hiwi, responsible: @wimi)

      expect(@hiwi.contracts.size).to eq(2)
    end
  end
end
