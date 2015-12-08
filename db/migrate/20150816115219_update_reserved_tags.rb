class UpdateReservedTags < ActiveRecord::Migration
  def change
    ReservedTag.delete_all
    ['VIP', '常客', '新注册', '沉睡'].each do |tag_name|
       ReservedTag.create(name: tag_name)
    end
  end
end
