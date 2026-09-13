class CreateEventFields < ActiveRecord::Migration[8.0]
  def change
    create_table :event_fields do |t|
      t.references :event, null: false, foreign_key: true
      t.string :label, null: false
      t.integer :field_type, null: false, default: 0
      t.boolean :required, null: false, default: false
      t.integer :position, null: false, default: 0
      t.text :options

      t.timestamps
    end

    add_index :event_fields, [ :event_id, :position ]
  end
end
