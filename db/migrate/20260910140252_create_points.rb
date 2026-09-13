class CreatePoints < ActiveRecord::Migration[8.0]
  def change
    create_table :points do |t|
      t.string :teacher_name, null: false
      t.string :phone, null: false
      t.string :street, null: false
      t.string :number
      t.string :complement
      t.string :neighborhood
      t.string :city, null: false
      t.string :state, null: false
      t.string :zip_code
      t.text :details
      t.decimal :latitude, precision: 10, scale: 6
      t.decimal :longitude, precision: 10, scale: 6
      t.string :geocode_status, default: "pending", null: false

      t.timestamps
    end

    add_index :points, [ :latitude, :longitude ]
  end
end
