require 'sinatra'
require 'active_support/core_ext/object/blank'
require 'sinatra/assetpack'
require 'coffee_script'
require 'json'
require 'slim'
require 'sass'

class App < Sinatra::Base
  set :root, File.dirname(__FILE__)
  set :views, Proc.new { "#{root}/app/views" }
  set :sass, Proc.new { { load_paths: [ "#{root}/app/css" ] } }

  register Sinatra::AssetPack

  assets do
    js :application, '/js/application.js', [
      '/js/lib/*.js',
      '/js/autogrow.js',
      '/js/torrent.js',
      '/js/app.js',
      '/js/social.js',
      '/js/spinner.js',
      '/js/main.js'
    ]

    css :application, '/css/application.css', [
      '/css/main.css'
    ]

    js_compression  :uglify
    css_compression :sass
  end

  get '/' do
    slim :home
  end

  get '/search' do
    content_type 'application/json', charset: 'utf-8'
    if params[:channel].blank? || params[:query].blank?
      status 422
      JSON.generate(success: false, error: 'invalid params')
    else
      torrents = SearchService.search(params[:query], params[:channel])
      JSON.generate(success: 1, torrents: torrents)
    end
  end

  post '/subscription' do
    $redis.sadd('newsletter', params[:email])
    content_type('application/json', charset: 'utf-8')
    JSON.generate(success: 1)
  end

end
