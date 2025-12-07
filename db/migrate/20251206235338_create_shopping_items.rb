class CreateShoppingItems < ActiveRecord::Migration[8.1]
  def change
    create_table :shopping_items do |t|
      t.string :name, null: false
      t.string :state, default: "active", null: false
      t.integer :position
      t.references :shopping_list, null: false, foreign_key: true

      t.timestamps
    end
    
    add_index :shopping_items, [:shopping_list_id, :position]
  end
end
