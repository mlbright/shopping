class CreateHouseholds < ActiveRecord::Migration[8.1]
  def change
    create_table :households do |t|
      t.string :name, null: false
      t.integer :creator_id, null: false

      t.timestamps
    end

    add_index :households, :creator_id
  end
end
