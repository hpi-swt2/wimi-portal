# == Schema Information
#
# Table name: trips
#
#  id                 :integer          not null, primary key
#  destination        :string
#  reason             :text
#  annotation         :text
#  user_id            :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  status             :integer          default(0)
#  signature          :boolean
#  person_in_power_id :integer
#

require 'rails_helper'

RSpec.describe Trip, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
