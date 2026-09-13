class CreateRegistrationAnswers < ActiveRecord::Migration[8.0]
  def change
    create_table :registration_answers do |t|
      t.references :registration, null: false, foreign_key: true
      t.references :event_field, null: false, foreign_key: true
      t.text :value

      t.timestamps
    end

    add_index :registration_answers, [ :registration_id, :event_field_id ], unique: true, name: "index_reg_answers_on_registration_and_field"
  end
end
