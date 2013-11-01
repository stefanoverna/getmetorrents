class @Nanny.HTTPClient

  class @DownloadFailed

  constructor: (@options) ->

  get: (callback) ->
    opts = $.merge(@options, { type: "GET", timeout: 1000 })
    $.ajax(opts)
      .fail(-> callback(new Nanny.HTTPClient.DownloadFailed))
      .done (doc) =>
        if @options['dataType']== "html"
          doc = $('<div/>').html(doc.replace(/src=['"]/g, "data-deferred-$&"))
        callback(null, doc)

  head: (callback) ->
    opts = $.merge(@options, { type: "HEAD", timeout: 1000 })
    $.ajax(opts)
      .fail(-> callback(new Nanny.HTTPClient.DownloadFailed))
      .done((response, state, request) -> callback(null, request))
