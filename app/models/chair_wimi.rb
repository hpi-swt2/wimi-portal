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

end
