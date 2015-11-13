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
