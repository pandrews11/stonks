class IngestStockDataJob < ApplicationJob
  queue_as :default

  def perform
    # Array of 'FinnhubRuby::StockSymbol's
    # could 429 rate limiting
    finnhub_stocks = finnhub_client.stock_symbols('US')

    Stock.delete_all
    Stock.insert_all!(sanitize_stocks(finnhub_stocks))
  end

  private

  def finnhub_client
    @finnhub_client ||= FinnhubRuby::DefaultApi.new
  end

  def sanitize_stocks(finnhub_stocks)
    finnhub_stocks.map { |finnhub_stock|
      {
        currency: finnhub_stock.currency,
        description: finnhub_stock.description,
        symbol: finnhub_stock.display_symbol,
        security_type: finnhub_stock.type
      }
    }
  end
end
