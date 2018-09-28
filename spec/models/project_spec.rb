# == Schema Information
#
# Table name: projects
#
#  id             :integer          not null, primary key
#  title          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  description    :string           default("")
#  status         :boolean          default(TRUE)
#  chair_id       :integer
#  project_leader :string           default("")
#

require 'rails_helper'

RSpec.describe Project, type: :model do
  let(:project) { FactoryGirl.create(:project) }
  let(:wimi1) { FactoryGirl.create(:wimi, chair: project.chair).user }
  let(:wimi2) { FactoryGirl.create(:wimi, chair: project.chair).user }

  before(:example) do
    project.users << wimi1
    project.users << wimi2
  end

  context '.wimis' do
    it 'returns all wimis in an unique array' do
      expect(project.wimis).to eq [wimi1, wimi2]
    end

    it 'does not include wimis from other chairs if they have a contract for the project chair' do
      other_wimi = FactoryGirl.create(:wimi).user
      FactoryGirl.create(:contract, hiwi: other_wimi, chair: project.chair)
      project.users << other_wimi

      expect(project.wimis.map(&:name)).not_to include(other_wimi.name)
    end
  end

  context '.hiwis' do
    it 'lists all hiwis of a project' do
      project.users << FactoryGirl.create(:user)
      project.users << FactoryGirl.create(:user)
      expect(project.hiwis.size).to eq(2)
    end

    it 'includes wimis from other chairs if they have a contract for the project chair' do
      other_wimi = FactoryGirl.create(:wimi).user
      FactoryGirl.create(:contract, hiwi: other_wimi, chair: project.chair)
      project.users << other_wimi

      expect(project.hiwis.map(&:name)).to include(other_wimi.name)
    end
  end

  it 'has a valid factory' do
    expect(FactoryGirl.create(:project)).to be_valid
  end
end
