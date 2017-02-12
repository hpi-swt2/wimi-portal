class RecreateEvents < ActiveRecord::Migration
  def change
  	create_table :events do |t|
  		t.references :user, index: true
  		t.references :target_user, index: true
  		t.references :object, polymorphic: true, index: true
  		t.datetime :created_at
  		t.integer :type
  	end
  end
end
