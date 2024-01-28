class StocksController < ApplicationController
  def index
    @stocks = Stock.all
    @stock_data_uploads = StockDataUpload.all
  end

  def show
    @stock = Stock.find(params[:id])

    finnhub_client = FinnhubRuby::DefaultApi.new
    @quote = finnhub_client.quote(@stock.ticker)
  end

  # admin
  def upload
    @data_file = params[:data_file]

    @sdu = StockDataUpload.create!(csv: @data_file)

    IngestStockDataJob.perform_later(@sdu.id)

    redirect_to stocks_path
  end
end
