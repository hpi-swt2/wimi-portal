class AlterUserRoles < ActiveRecord::Migration
  def change
    for user in User.all
      case user.role
        when "user"
          user.update(role: '1')
        when "hiwi"
          user.update(role: '2')
        when "wimi"
          user.update(role: '3')
        when "admin"
          user.update(role: '4')
        when "superadmin"
          user.update(role: '5')
      end
    end
    change_column :users, :role, :integer
  end
end
