require 'coffee_script'
require 'uglifier'

guard 'sprockets', destination: 'public/javascripts', asset_paths: ['app/assets/javascripts'], root_file: 'app/assets/javascripts/application.js.coffee', minify: true do
  watch %r{app/assets/javascripts/(.*)\.js(\.coffee)}
end

guard 'sass', input: 'app/assets/stylesheets', output: 'public/stylesheets'
