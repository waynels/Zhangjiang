host = Rails.env.production? ? ENV['REDIS_HOST'] : 'localhost'
$redis = Redis.new(host: host, port: 6379, db: 1, namespace: 'rails-redis')
# Redis DB in use
# 0: cache store
# 1: countable
# 10: sidekiq
# 15: wechat_authorize
