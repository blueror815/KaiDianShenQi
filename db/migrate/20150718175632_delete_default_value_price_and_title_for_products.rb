class DeleteDefaultValuePriceAndTitleForProducts < ActiveRecord::Migration
  def change
    change_column_default :products, :price, nil
    change_column_default :products, :title, nil
  end
end
