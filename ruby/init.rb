require 'bundler/setup'
require 'active_support/dependencies'
require 'socky/client'
require 'socky/server'
require 'resque'
require 'resque/server'

autoload_paths = ActiveSupport::Dependencies.autoload_paths
%w(app/services app/jobs).each do |path|
  autoload_paths.push(path) unless autoload_paths.include?(path)
end

require './config'

socky_url = NannyConfig::HOST + '/http/getmetorrents'
$socky = Socky::Client.new(socky_url, NannyConfig::SOCKY_PASSWORD)
$redis = Redis.new(url: NannyConfig::REDIS_URL)
Resque.redis = $redis
Resque.redis.namespace = NannyConfig::RESQUE_NAMESPACE
