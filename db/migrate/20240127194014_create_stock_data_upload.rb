class CreateStockDataUpload < ActiveRecord::Migration[7.1]
  def change
    create_table :stock_data_uploads do |t|
      t.timestamps
    end
  end
end
