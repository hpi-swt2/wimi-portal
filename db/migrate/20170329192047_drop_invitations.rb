require_relative '20160109212727_add_sender_to_invitation'
require_relative '20151212165410_create_invitations'

class DropInvitations < ActiveRecord::Migration
  def change
    revert AddSenderToInvitation
    revert CreateInvitations
  end
end
