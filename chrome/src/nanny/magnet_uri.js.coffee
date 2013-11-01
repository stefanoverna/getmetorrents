class @Nanny.MagnetUri
  HASH_REGEXP = /xt=urn:btih:([a-z0-9]+)/i

  constructor: (@uri) ->

  @property 'hash',
    get: -> @uri.match(HASH_REGEXP)[1]

