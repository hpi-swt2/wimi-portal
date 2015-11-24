# == Schema Information
#
# Table name: users
#
#  id                 :integer          not null, primary key
#  email              :string           default(""), not null
#  sign_in_count      :integer          default(0), not null
#  current_sign_in_at :datetime
#  last_sign_in_at    :datetime
#  current_sign_in_ip :string
#  last_sign_in_ip    :string
#  first              :string
#  last_name          :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  identity_url       :string
#

require 'rails_helper'

RSpec.describe User, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
