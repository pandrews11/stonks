# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

finnhub_client = FinnhubRuby::DefaultApi.new
finnhub_stocks = finnhub_client.stock_symbols('US')

Stock.insert_all!(
  finnhub_stocks.map { |finnhub_stock|
    {
      currency: finnhub_stock.currency,
      description: finnhub_stock.description,
      symbol: finnhub_stock.display_symbol,
      security_type: finnhub_stock.type
    }
  }
)

Stock.__elasticsearch__.create_index!
Stock.import
