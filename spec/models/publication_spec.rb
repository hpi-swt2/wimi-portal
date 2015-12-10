# == Schema Information
#
# Table name: publications
#
#  id         :integer          not null, primary key
#  title      :string
#  venue      :string
#  type_      :string
#  project_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Publication, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
