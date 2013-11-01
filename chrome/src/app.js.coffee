#= require nanny

#= require lib/mustache
#= require lib/spin
#= require lib/autogrow

#= require web/app
#= require web/spinner
#= require web/torrent_view

$ ->
  app = new App
  app.run()



