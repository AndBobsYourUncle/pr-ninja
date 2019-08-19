require 'redis'

# URL should be in the format redis://:[password]@[hostname]:[port]/[db]
# TODO possibly pass :driver => :hiredis per https://github.com/redis/redis-rb#hiredis
REDIS = Redis.new(url: Settings.redis_url)

REDIS.instance_eval do
  def lock_manager
    # lazy-load redlock client due to odd redis initialization sequence on review apps
    @lock_manager ||= Redlock::Client.new([self])
  end

  def lock(*args)
    lock_manager.lock(*args)
  end

  def unlock(*args)
    lock_manager.unlock(*args)
  end

  def lock!(*args, &block)
    lock_manager.lock!(*args, &block)
  end
end
