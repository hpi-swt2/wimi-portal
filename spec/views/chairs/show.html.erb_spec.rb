require 'rails_helper'

RSpec.describe 'chairs/show' do
  before :each do
    @chair = FactoryBot.create(:chair)
    @contract = FactoryBot.create(:contract, chair: @chair)
    @hiwi = @contract.hiwi
    @project = FactoryBot.create(:project, chair: @chair)
    @hiwi.projects << @project

    @hiwi_no_contract = FactoryBot.create(:user)
    @hiwi_no_contract.projects << @project

    @hiwi_two_contracts = FactoryBot.create(:user)
    FactoryBot.create(:contract, chair: @chair, hiwi: @hiwi_two_contracts)
    FactoryBot.create(:contract, chair: @chair, hiwi: @hiwi_two_contracts)
    @hiwi_two_contracts.projects << @project

    login_as @hiwi
    allow(view).to receive(:current_user).and_return(@hiwi)
    visit chair_path(@chair)
  end
  
  context 'as a hiwi' do
    it 'does not link contracts for other hiwis' do
      within("#hiwi_table") do
        expect(page).to_not have_selector(:linkhref, contracts_path)
        expect(page).to_not have_content(I18n.t('chairs.contracts.none'))
      end
    end

    it 'has a link to the hiwis contract page' do
      within("#hiwi_table") do
        expect(page).to have_selector(:linkhref, contract_path(@contract))
      end
    end
  end
end
