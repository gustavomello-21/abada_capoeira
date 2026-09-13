class CreateEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :events do |t|
      t.string :title, null: false
      t.datetime :starts_at
      t.datetime :ends_at
      t.date :registration_deadline
      t.string :status, default: "draft", null: false

      t.timestamps
    end
  end
end
