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

class User < ActiveRecord::Base

  devise  :openid_authenticatable, :trackable

  validates :first, length: { minimum: 1 }
  validates :last_name, length: { minimum: 1 }
  validates :email, length: { minimum: 1 }

  has_many :holidays
  has_many :expenses
  has_many :trips

  has_and_belongs_to_many :publications
  has_and_belongs_to_many :projects

  def name
    "#{first} #{last_name}"
  end

  def name=(fullname)
    first, last = fullname.split(' ')
    self.first = first
    self.last_name = last
  end

  def self.openid_required_fields
    ["http://axschema.org/contact/email"]
  end

  def self.build_from_identity_url(identity_url)
    username = identity_url.split('/')[-1]
    first = username.split('.')[0].titleize
    last_name = username.split('.')[1].titleize.delete("0-9")
    User.new(:first => first, :last_name => last_name, :identity_url => identity_url)
  end

  def openid_fields=(fields)
    fields.each do |key, value|
      # Some AX providers can return multiple values per key
      if value.is_a? Array
        value = value.first
      end

      case key.to_s
      when "http://axschema.org/contact/email"
        update_attribute(:email, value)
      else
        logger.error "Unknown OpenID field: #{key}"
      end
    end
  end
end
