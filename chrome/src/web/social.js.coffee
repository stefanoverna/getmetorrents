loadSdk = (id, url) ->
  fj = document.getElementsByTagName("script")[0]
  unless document.getElementById(id)
    js = document.createElement("script")
    js.id = id
    js.async = true
    js.src = url
    fj.parentNode.insertBefore js, fj

loadSdk('google-plus', '//apis.google.com/js/plusone.js')
loadSdk('facebook', '//connect.facebook.net/en_US/all.js#xfbml=1')
loadSdk('twitter', '//platform.twitter.com/widgets.js')
loadSdk('analytics', '//www.google-analytics.com/ga.js')
loadSdk('uservoice', '//widget.uservoice.com/3qt8tmc1ZZJXRuwAcg4fyA.js')
loadSdk('flattr', '//api.flattr.com/js/0.6/load.js?mode=auto')

window._gaq = [ ['_setAccount', 'UA-38365593-1'], ['_trackPageview'] ]

