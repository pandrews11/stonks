class FinnhubProxy
  def quote(symbol)
    cache_key = "#{symbol}/quote"
    Rails.cache.fetch(cache_key, expires_in: 10.minutes) do
      finnhub_client.quote(symbol)
    end
  end

  def recommendation_trends(symbol)
    cache_key = "#{symbol}/recommendation_trends"
    Rails.cache.fetch(cache_key, expires_in: 30.minutes) do
      finnhub_client.recommendation_trends(symbol)
    end
  end

  def company_news(symbol, start_date, end_date)
    cache_key = "#{symbol}/company_news/#{start_date}/#{end_date}"
    Rails.cache.fetch(cache_key, expires_in: 1.day) do
      finnhub_client.company_news(symbol, start_date, end_date)
    end
  end

  private

  def finnhub_client
    @finnhub_client ||= FinnhubRuby::DefaultApi.new
  end
end
