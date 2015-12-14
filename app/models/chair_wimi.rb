class ChairWimi < ActiveRecord::Base
  belongs_to :user
  belongs_to :chair
  validates :user, :chair, presence: true

  def remove(current_user)
    if current_user == self.user || self.representative
      return false
    end
    self.destroy
  end

  def withdraw_admin(current_user)
    if current_user == self.user || ChairWimi.where(admin: true).count == 1
      return false
    else
      self.admin = false
      self.save
    end
  end
  
  def is_admin?
    return self.admin
  end

  def is_representative?
    return self.representative
  end
end
