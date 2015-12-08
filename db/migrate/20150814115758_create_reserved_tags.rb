class CreateReservedTags < ActiveRecord::Migration
  def change
    create_table :reserved_tags do |t|
      t.string :name

      t.timestamps null: false
    end

    ['VIP', 'Regular', 'New', 'Inactive'].each do |tag_name|
      ReservedTag.create(name: tag_name)
    end
  end
end
