require 'rails_helper'

describe 'contracts#index' do
  before :each do
    @wimi = FactoryBot.create(:wimi).user
    @hiwi = FactoryBot.create(:hiwi, responsible: @wimi)
    @contract = @hiwi.contracts.first
  end

  context "with a single contract" do
    it 'shows contracts#index for a WiMi (as it includes the New button)' do
      login_as @wimi
      visit contracts_path
      expect(page).to have_current_path(contracts_path)
      expect(page).to have_content I18n.t('helpers.titles.new', model: Contract.model_name.human.titleize)
    end

    it 'redirects to contracts#show as a HiWi' do
      login_as @hiwi
      visit contracts_path
      expect(page).to have_current_path(contract_path(@contract))
    end
  end
end
