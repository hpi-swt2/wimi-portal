require 'rails_helper'

RSpec.describe 'time_sheets/show', type: :view do
  context 'as a student with a contract' do
    context 'with a "created" time sheet' do
      it 'is possible to close it' do
        time_sheet = FactoryBot.create(:time_sheet)
        login_as time_sheet.user
        visit time_sheet_path(time_sheet)

        expect(page).to have_content(I18n.t("activerecord.attributes.time_sheet.status_enum.created"))

        click_on I18n.t('helpers.links.close', model: TimeSheet.model_name.human.titleize)

        expect(page).to have_current_path(time_sheet_path(time_sheet))
        expect(page).to have_content(I18n.t("activerecord.attributes.time_sheet.status_enum.closed"))
        expect(page).to have_success_flash_message
        expect(page).to_not have_danger_flash_message
      end
    end
  end
end
