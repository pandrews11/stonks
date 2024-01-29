class StocksController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :stock_not_found

  STOCK_DISPLAY_LIMIT = 100

  def index
    @q = params[:q]

    @stocks = if @q.present?
      query = Search::StockQuery.call(@q)
      response = Stock.search(query)
      response.records.records.limit(STOCK_DISPLAY_LIMIT)
    else
      Stock.limit(STOCK_DISPLAY_LIMIT)
    end
  end

  def show
    @stock = Stock.find(params[:id])
    @quote = finnhub_client.quote(@stock.symbol)
    @recommendation_trend = finnhub_client.recommendation_trends(@stock.symbol).first
  end

  private

  def finnhub_client
    @finnhub_client ||= FinnhubRuby::DefaultApi.new
  end

  def stock_not_found
    render :not_found
  end
end
