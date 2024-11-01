Sidekiq.configure_server do |config|
  config.redis = { host: ENV['REDIS_HOST'], port: '6379', db: 10 }
  # config.server_middleware do |chain|
  #   chain.add Sidekiq::JobRetry, max_retries: 1
  # end
end

Sidekiq.configure_client do |config|
  config.redis = { host: ENV['REDIS_HOST'], port: '6379', db: 10 }
end
