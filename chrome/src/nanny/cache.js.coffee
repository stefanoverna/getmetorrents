class @Nanny.Cache

  class @HashNotFound

  urlFor: (hash, callback) ->
    find = (successUrl, url, cb) ->
      if successUrl
        cb(null, successUrl)
      else
        new Nanny.HTTPClient(url: url)
          .head (err, request) ->
            if err
              cb(null, null)
            else
              cb(null, url)

    urls = [ @buildTorcacheUrl(hash), @buildTorrageUrl(hash) ]
    async.reduce urls, null, find, (err, url) ->
      if url
        callback(null, url)
      else
        callback(new Nanny.Cache.HashNotFound)

  buildTorcacheUrl: (hash) ->
    "http://torcache.net/torrent/#{hash}.torrent"

  buildTorrageUrl: (hash) ->
    "http://torrage.com/torrent/#{hash}.torrent"

