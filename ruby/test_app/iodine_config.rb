require 'etc'
Iodine.threads = ENV['THREADS'] || 1
Iodine.workers = ENV['WORKERS'] || Etc.nprocessors

if ENV['REDIS_URL']
  Iodine::PubSub.default = Iodine::PubSub::Redis.new(ENV['REDIS_URL'])
  puts "* Using Redis for pub/sub."
else
  puts "* Using Iodine for pub/sub within the process cluster."
end
