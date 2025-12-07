class CreateShoppingLists < ActiveRecord::Migration[8.1]
  def change
    create_table :shopping_lists do |t|
      t.string :name
      t.references :household, null: false, foreign_key: true
      t.integer :creator_id

      t.timestamps
    end
  end
end
