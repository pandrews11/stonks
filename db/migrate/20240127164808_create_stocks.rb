class CreateStocks < ActiveRecord::Migration[7.1]
  def change
    create_table :stocks do |t|
      t.string :currency
      t.string :description
      t.string :symbol
      t.string :security_type

      t.index :symbol, unique: true

      t.timestamps
    end
  end
end
