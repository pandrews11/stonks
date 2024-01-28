class StocksController < ApplicationController
  def index
    @stocks = Stock.limit(100)
  end

  def show
    @stock = Stock.find(params[:id])

    finnhub_client = FinnhubRuby::DefaultApi.new
    @quote = finnhub_client.quote(@stock.symbol)
  end

  # admin
  def upload
    redirect_to stocks_path
  end
end
