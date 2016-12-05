require 'rails_helper'

describe 'time sheets' do
  before :each do
    @hiwi = FactoryGirl.create(:hiwi)
    @wimi = FactoryGirl.create(:wimi).user
    @contract = FactoryGirl.create(:contract, hiwi: @hiwi, responsible: @wimi)
    login_as @hiwi
  end

  context 'that are handed in' do
    it 'cannot be edited' do
      @time_sheet_handed_in = FactoryGirl.create(:time_sheet, contract: @contract, handed_in: true)
      
      visit time_sheet_path(@time_sheet_handed_in)
      
      expect(page).not_to have_content('Edit')
      hiwi_ability = Ability.new(@hiwi)
      expect(hiwi_ability.can?(:edit, @time_sheet)).to be false
    end
  end

  context 'that are not handed in' do
    it 'can be edited' do
      @time_sheet_new = FactoryGirl.create(:time_sheet, contract: @contract)

      visit time_sheet_path(@time_sheet_new)

      expect(page).to have_content('Edit')
      hiwi_ability = Ability.new(@hiwi)
      expect(hiwi_ability.can?(:edit, @time_sheet)).to be false
    end
  end
end