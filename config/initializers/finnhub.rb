FinnhubRuby.configure do |config|
  config.api_key['api_key'] = Rails.application.credentials.finnhub.api_key
end
