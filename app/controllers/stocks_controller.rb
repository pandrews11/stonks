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
    @quote = finnhub_proxy.quote(@stock.symbol)
    @recommendation_trends = finnhub_proxy.recommendation_trends(@stock.symbol)
    @company_news = finnhub_proxy.company_news(@stock.symbol, 7.days.ago.strftime('%Y-%m-%d'), Time.now.strftime('%Y-%m-%d'))

    respond_to do |format|
      format.html
      format.json { render json: {stock: @stock, quote: @quote, recommendation_trends: @recommendation_trends}.to_json, status: :ok}
    end
  end

  private

  def finnhub_proxy
    @finnhub_proxy ||= FinnhubProxy.new
  end

  def stock_not_found
    render :not_found
  end
end
