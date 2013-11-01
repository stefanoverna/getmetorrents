class @Nanny.Search
  SIZE_UNITS = [ 'b', 'kb', 'mb', 'gb', 'tb' ]
  FEED_DESC_REGEXP = /// Size: \s* (\d+) \s* ([KMGT]?B)
    .*
    Seeds: \s* ([\d,]+)
    \s+
    Peers: \s* ([\d,]+)
    \s+
    Hash: \s* ([a-f0-9]+)
  ///i

  searchTorrents: (query, callback) ->
    @documentForQuery query, (err, $doc) =>
      if err
        callback(err)
      else
        torrents = _.map $doc.find('item'), (item) =>
          @torrentFromItem($(item))
        callback(null, torrents)

  torrentFromItem: ($node) ->
    data = {}

    for i in ['title', 'link', 'pubDate', 'description']
      data[i] = $node.find(i).text()

    matches = data.description.match FEED_DESC_REGEXP
    _.each [ 'description', 'size', 'sizeUnit', 'seeds', 'peers', 'hash' ], (field, i) ->
      data[field] = matches[i]

    data.seeds = parseInt(data.seeds)
    data.peers = parseInt(data.peers)
    data.pubDate = new Date(data.pubDate)

    exp = SIZE_UNITS.indexOf data.sizeUnit.toLowerCase()
    data.size = parseInt(data.size) * Math.pow(1024, exp)

    new Nanny.Torrent(data)

  documentForQuery: (query, callback) ->
    new Nanny.HTTPClient(
      url: "http://torrentz.eu/feed",
      data: { q: query },
    ).get (err, data) -> callback(err, $(data))

