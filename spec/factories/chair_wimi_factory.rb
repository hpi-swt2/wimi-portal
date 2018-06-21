# == Schema Information
#
# Table name: chair_wimis
#
#  id             :integer          not null, primary key
#  admin          :boolean          default(FALSE)
#  representative :boolean          default(FALSE)
#  application    :string
#  user_id        :integer
#  chair_id       :integer
#  secretary      :boolean
#

FactoryBot.define do
  factory :wimi, class: 'ChairWimi' do
    user
    chair
    application 'accepted'
  end

  factory :admin, class: 'ChairWimi' do
  	user
  	chair
  	admin true
  	application 'accepted'
  end

  factory :representative, class: 'ChairWimi' do
  	user 
  	chair
  	representative true
  	application 'accepted'
  end

  factory :secretary, class: 'ChairWimi' do
  	user 
  	chair
  	secretary true
  	application 'accepted'
  end
end
