require 'rails_helper'



feature "First login as User" do
  background do
    @current_user = FactoryGirl.create(:user)
    login_as @current_user
  end

  scenario "Display all chairs" do
    chairs.each do |chair|
      expect(page).to have_content(chair.name)
    end
  end

end