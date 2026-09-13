class CreateRegistrations < ActiveRecord::Migration[8.0]
  def change
    create_table :registrations do |t|
      t.references :event, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :status, null: false, default: 0
      t.text :rejection_reason

      t.timestamps
    end

    add_index :registrations, [ :event_id, :user_id ], unique: true
  end
end
