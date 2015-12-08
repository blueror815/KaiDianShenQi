class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :title, default: ""
      t.decimal :price, default: 0.0
      t.text :description, default: ""
      t.integer :barcode, default: 123

      t.timestamps null: false
    end
    add_index :products, :barcode
  end
end
