Sidekiq.configure_server do |config|
  config.redis = Rails.application.config_for(:redis).merge(db: 1)
end

Sidekiq.configure_client do |config|
  config.redis = Rails.application.config_for(:redis).merge(db: 1)
end
