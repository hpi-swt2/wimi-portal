# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  first                  :string
#  last_name              :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  identity_url           :string
#  username               :string
#  token                  :string
#

class User < ActiveRecord::Base
  devise  :openid_authenticatable, :trackable

  has_many :holiday
  has_many :expense
  has_many :trip
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
    ["gender", "nickname", "email"]
  end 
  
  def self.build_from_identity_url(identity_url)
    User.new(:identity_url => identity_url)
  end
    
  def openid_fields=(fields)
    fields.each do |key, value|
      # Some AX providers can return multiple values per key
      if value.is_a? Array
        value = value.first
      end
    
      case key.to_s
      when "nickname"
        self.username = value
      when "email"
        self.email = value
      when "gender"
        self.token = value
      else
        logger.error "Unknown OpenID field: #{key}"
      end
    end
  end 
end
