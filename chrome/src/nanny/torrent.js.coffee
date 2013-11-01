class Nanny.Torrent
  ATTRIBUTES = [ 'title', 'link', 'size', 'seeds', 'peers', 'hash', 'pubDate' ]

  class @URLNotFound

  constructor: (attrs) ->
    for attr in ATTRIBUTES
      @[attr] = attrs[attr]

  @property 'humanSize',
    get: ->
      return "0B" if @size == 0
      units = [ 'B', 'KB', 'MB', 'GB', 'TB' ]
      e = Math.floor(Math.log(@size)/Math.log(1024))
      size = (@size / Math.pow(1024, e)).toFixed(1)
      size.replace /\.0?$/, units[e]

  getTorrentUrl: (callback) ->
    new Nanny.Cache().urlFor @hash, (err, url) =>
      if err instanceof Nanny.Cache.HashNotFound
        @getTrackersTorrentUrl (err, url) =>
          callback(err, url)
      else
          callback(null, url)

  getTrackersTorrentUrl: (callback) ->
    @getTrackers (err, trackers) ->
      if err
        callback(err)
      else
        findUrl = (url, tracker, cb) ->
          if url
            cb(null, url)
          else
            tracker.getTorrentUrl (err, url) ->
              if err instanceof Nanny.Tracker.TorrentNotFound
                cb(null, null)
              else
                cb(null, url)

        async.reduce trackers, null, findUrl, (err, url) ->
          if url
            callback(null, url)
          else
            callback(new Nanny.Torrent.URLNotFound)

  getTrackers: (callback) ->
    new Nanny.HTTPClient(
      url: @link,
      timeout: 1000,
      dataType: 'html'
    ).get (err, $doc) ->
      if (err)
        callback(err)
      else
        links = $doc.find(".download dl dt a[href^=http]")
        links = _.map(links, (link) -> new Nanny.Tracker($(link).attr('href')))
        callback(null, links)


