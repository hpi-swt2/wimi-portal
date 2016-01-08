require 'rails_helper'

RSpec.describe 'projects/show', type: :view do
  before(:each) do
    @user = FactoryGirl.create(:user)
    sign_in @user
    @project = assign(:project, FactoryGirl.create(:project))
    allow(view).to receive(:current_user).and_return(@user)
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Factory Project/)
  end

  context 'as hiwi' do

    it 'expects leave project button if part of project' do
      @project.users << @user
      render
      expect(rendered).to have_content('Leave')
    end

    it 'expects no leave project button if not part of project' do
      render
      expect(rendered).to_not have_content('Leave')
    end

  end
end
