class AddSenderToInvitation < ActiveRecord::Migration
  def change
    change_table :invitations do |t|
      t.references :sender, index: true
    end
  end
end
