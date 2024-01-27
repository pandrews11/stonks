class StocksController < ApplicationController
  def index
    @stocks = Stock.all
  end

  # admin
  def upload
    @file = params[:file]
    flash[:notice] = 'File successfully uploaded.'

    redirect_to stocks_path
  end
end
