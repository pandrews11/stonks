require 'csv'

class IngestStockDataJob < ApplicationJob
  queue_as :default

  def perform(stock_data_upload_id)
    stock_data_upload = StockDataUpload.find(stock_data_upload_id)

    # Wipe all current stock data, we are starting fresh.
    Stock.delete_all

    csv_filepath = ActiveStorage::Blob.service.path_for(stock_data_upload.csv.key)

    # Insert new stock data.
    CSV.foreach(csv_filepath, headers: true) do |row|
      Stock.create!(ticker: row[0], name: row[1], exchange: row[2], country: row[4])
    end
  end
end
