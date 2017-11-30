# == Schema Information
#
# Table name: chairs
#
#  id           :integer          not null, primary key
#  name         :string
#  abbreviation :string
#  description  :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Chair < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  has_many :chair_wimis, dependent: :destroy
  has_many :users, through: :chair_wimis
  has_many :projects, dependent: :destroy
  has_many :events, as: :object, dependent: :destroy
  has_many :work_days, through: :projects
  has_many :contracts

  validates :name, presence: true

  def wimis
    users.select(&:is_wimi?)
  end

  def hiwis
    projects.collect(&:hiwis).flatten.uniq
  end

  def admins
    chair_wimis.select(&:is_admin?)
  end

  def admin_users
    admins.collect(&:user)
  end

  def representative
    chair_wimis.find(&:is_representative?)
  end

  def check_correct_user(id)
    user = User.find_by(id: id)
    if !user || user.is_superadmin?
      return false
    elsif user.chair_wimi && user.chair_wimi.application == 'accepted'
      if user.chair_wimi.chair != self
        return false
      end
    end
    true
  end

  def set_initial_users(admins_param, representative_param)
    success = true

    admin_array = []
    admins_param.try(:each) do |id|
      success = check_correct_user(id[1])
      return false unless success
      admin_array << User.find_by(id: id[1])
    end
    success = check_correct_user(representative_param) if representative_param

    if success
      set_admins(admin_array)
      set_representative(User.find_by_id(representative_param)) if representative_param
      return true
    else
      return false
    end
  end

  def set_admins(admin_array)
    admins.each do |admin|
      admin.admin = false
      admin.save
    end

    admin_array.try(:each) do |admin|
      chair_wimi = ChairWimi.find_by(user: admin)
      if chair_wimi
        admin.chair_wimi.destroy
      end
      ChairWimi.create(chair: self, user: admin, admin: true, application: 'accepted')
    end
  end

  def set_representative(new_representative)
    while representative
      former = representative
      former.representative = false
      former.save!
    end

    if new_representative
      chair_wimi = ChairWimi.find_by(user: new_representative, chair: self)
      if chair_wimi
        if chair_wimi.application == 'pending'
          chair_wimi.destroy!
          ChairWimi.create(chair: self, user: new_representative, representative: true, application: 'accepted')
        else
          chair_wimi.representative = true
          chair_wimi.save!
        end
      else
        ChairWimi.create!(chair: self, user: new_representative, representative: true, application: 'accepted')
      end
    end
  end

  def reporting_for_year(year)
    all_contract_salaries = Hash[self.contracts.collect{|contract| [contract.id,contract.reporting_for_year(year)]}]
    reporting_info = {}
    all_contract_salaries.each do |contractid, info|
      info.each do |projectname, salaries|
        if reporting_info[projectname]
          # element-wise addition
          # see also https://stackoverflow.com/questions/2682411/ruby-sum-corresponding-members-of-two-or-more-arrays
          # reporting_info[projectname] = [reporting_info[projectname],salaries].transpose.map{|x| x.reduce(:+)}
          reporting_info[projectname][contractid] = salaries
        else
          reporting_info[projectname] = Hash[contractid, salaries]
        end
      end
    end
    return reporting_info
  end

  def reporting_contract_info(year)
    info = {}
    self.contracts.year(year).each do |contract|
      info[contract.id] = {
        userid: contract.hiwi.id,
        username: contract.hiwi.name,
        contractname: contract.name,
        responsible: contract.responsible.name,
        responsibleid: contract.responsible.id
      }
    end
    return info
  end

  def reporting_project_info(year)
    info = {}
    self.contracts.year(year).each do |contract|
      contract.hiwi.projects.each do |project|
        info[project.name] = {
          id: project.id
        }
      end
    end
    return info
  end
end
