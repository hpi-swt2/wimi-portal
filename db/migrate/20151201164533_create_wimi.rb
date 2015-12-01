class CreateWimi < ActiveRecord::Migration
  def change
    create_table :wimis do |t|
      t.boolean :admin, default: false
      t.boolean :representative, default: false
      t.string :application, default: nil
      t.belongs_to :user, index: true
      t.belongs_to :chair, index: true
    end
  end
end
