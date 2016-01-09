class AddInvitationToEvent < ActiveRecord::Migration
  def change
    change_table :events do |t|
      t.references :invitation
    end
  end
end
