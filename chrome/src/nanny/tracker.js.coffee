class Nanny.Tracker

  class @MagnetNotFound
  class @TorrentNotFound

  constructor: (@trackerUrl) ->

  getMagnetUri: (callback) ->
    @getPage (err, $page) ->
      if err
        callback(new Nanny.Tracker.MagnetNotFound)
      else
        link = $page.find("a[href^='magnet:']").eq(0)
        if link.length
          callback(null, new Nanny.MagnetUri(link[0].href))
        else
          callback(new Nanny.Tracker.MagnetNotFound)

  getTorrentUrl: (callback) ->
    @getPage (err, $page) =>
      if err
        callback(new Nanny.Tracker.TorrentNotFound)
      else
        link = $page.find("a[href$='.torrent']").get()
        if link.length == 0
          callback(new Nanny.Tracker.TorrentNotFound)
        else
          link = link[0]
          url = @urlPrefix() + link.pathname + link.search + link.hash
          new Nanny.HTTPClient(url: url)
            .head (error, request) ->
              if error
                callback(new Nanny.Tracker.TorrentNotFound)
              else
                isTorrent = request.getResponseHeader('Content-Type').match /bittorrent|octet/i
                if isTorrent
                  callback(null, url)
                else
                  callback(new Nanny.Tracker.TorrentNotFound)

  getPage: (callback) ->
    new Nanny.HTTPClient(url: @trackerUrl, dataType: "html").get(callback)

  urlPrefix: ->
    parser = document.createElement('a')
    parser.href = @trackerUrl
    parser.protocol + "//" + parser.host

