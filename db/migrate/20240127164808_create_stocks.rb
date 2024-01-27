class CreateStocks < ActiveRecord::Migration[7.1]
  def change
    create_table :stocks do |t|
      t.string :name, null: false
      t.string :ticker, null: false
      t.index :ticker, unique: true
      t.string :exchange
      t.string :country

      t.timestamps
    end
  end
end
