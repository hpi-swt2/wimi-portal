require 'rails_helper'
require 'cancan/matchers'

RSpec.describe 'time_sheets/show', type: :view do  
  def prepare_render(time_sheet, user)
    allow(view).to receive(:current_user).and_return(user)
    allow(view).to receive(:user_signed_in?).and_return(!!user)
    allow(time_sheet).to receive(:user).and_return(time_sheet.contract.hiwi)
    assign(:time_sheet, time_sheet)
    stub_template "time_sheets/_send_to_secretary_prompt.html" => ""
  end

  context 'as a student with a contract' do
    context 'with a time sheet in the states "pending", "rejected" and "closed"' do
      it 'cannot be closed' do
        [:rejected, :pending, :closed].each do |status|
          time_sheet = FactoryBot.build_stubbed(:time_sheet, status: status)
          user = time_sheet.contract.hiwi
          prepare_render(time_sheet, user)
          
          render

          expect(rendered).to have_content(I18n.t("activerecord.attributes.time_sheet.status_enum.#{status}"))
          expect(rendered).to_not have_selector(:link_or_button, I18n.t('helpers.links.close', model: TimeSheet.model_name.human.titleize))
          expect(rendered).to_not have_css("*[href='#{close_time_sheet_path(time_sheet)}']")
        end
      end

      it 'cannot be reopened' do
        [:rejected, :pending, :closed].each do |status|
          time_sheet = FactoryBot.build_stubbed(:time_sheet, status: status)
          user = time_sheet.contract.hiwi
          prepare_render(time_sheet, user)

          render

          expect(rendered).to_not have_selector(:link_or_button, I18n.t('helpers.links.reopen'))
          expect(rendered).to_not have_css("*[href='#{reopen_time_sheet_path(time_sheet)}']")
        end
      end
    end
  end

  context 'as a chair staff member' do
    context 'with a time sheet in the states "created", "pending", "rejected" and "closed"' do
      it 'cannot be closed' do
        [:created, :rejected, :pending, :closed].each do |status|
          time_sheet = FactoryBot.build_stubbed(:time_sheet, status: status)
          user = time_sheet.contract.responsible
          prepare_render(time_sheet, user)
          
          render

          expect(rendered).to have_content(I18n.t("activerecord.attributes.time_sheet.status_enum.#{status}"))
          expect(rendered).to_not have_selector(:link_or_button, I18n.t('helpers.links.close', model: TimeSheet.model_name.human.titleize))
          expect(rendered).to_not have_css("*[href='#{close_time_sheet_path(time_sheet)}']")
        end
      end

      it 'cannot be reopened' do
        [:created, :rejected, :pending, :closed].each do |status|
          time_sheet = FactoryBot.build_stubbed(:time_sheet, status: status)
          user = time_sheet.contract.responsible
          prepare_render(time_sheet, user)

          render

          expect(rendered).to_not have_selector(:link_or_button, I18n.t('helpers.links.reopen'))
          expect(rendered).to_not have_css("*[href='#{reopen_time_sheet_path(time_sheet)}']")
        end
      end
    end
  end
end
