class StockDataUpload < ApplicationRecord
  has_one_attached :csv
end
