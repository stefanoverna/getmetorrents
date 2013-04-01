require './init'
require './app'
require 'pp'

if NannyConfig::RESQUE_AUTH
  Resque::Server.use Rack::Auth::Basic do |username, password|
    username == 'resque' && password == NannyConfig::RESQUE_AUTH
  end
end

socky_options = {
  debug: NannyConfig::SOCKY_DEBUG,
  applications: {
    getmetorrents: NannyConfig::SOCKY_PASSWORD
  }
}

class Shrimp
  def initialize(app)
    @app = app
  end

  def call(env)
    env.each do |k,v|
      if k =~ /^HTTP_/i || k == 'REQUEST_METHOD' || k == 'PATH_INFO' || k == 'QUERY_STRING' 
        puts "#{k} -> #{v.inspect}"
      end
    end
    body = env['rack.input'].read
    puts "Body: #{body}"
    env['rack.input'].rewind
    status, header, body = @app.call(env)
    puts "Status: #{status}"
    puts "-" * 10
    [ status, header, body ]
  end
end

use Shrimp

run Rack::URLMap.new({
  "/"          =>  App.new,
  "/jobs"      =>  Resque::Server.new,
  '/websocket' =>  Socky::Server::WebSocket.new(socky_options),
  '/http'      =>  Socky::Server::HTTP.new(socky_options)
})
