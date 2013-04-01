port = window.location.port
port = ":#{port}" if port.length > 0
socky = new Socky.Client("ws://#{window.location.hostname}#{port}/websocket/getmetorrents")

@App = Sammy 'body', ->
  NO_RESULTS_TEMPLATE = '<tr><td colspan="5" class="no-results">No results found!</td></tr>'

  @helpers
    guid: ->
      (Math.floor(Math.random()*16).toString(16) for i in [0 .. 13]).join("")
    toggleResults: (toggle) ->
      $("#results").toggle(toggle)
      @resultsContainer().empty()
    toggleSearchForm: (toggle) ->
      $("#search").toggle(toggle)
    toggleLoading: (toggle) ->
      $("#loading").toggle(toggle)
    toggleAbout: (toggle) ->
      @toggleLoading(!toggle)
      @toggleResults(!toggle)
      @toggleSearchForm(!toggle)
      $("#about").toggle(toggle)
    floatSearchForm: (toggle) ->
      $("#search").toggleClass('floating', toggle)
    resultsContainer: ->
      $("#results tbody")
    fillWithResults: (torrents, channel) ->
      @toggleResults(true)
      @toggleLoading(false)
      if torrents.length == 0
        @resultsContainer().empty().html(NO_RESULTS_TEMPLATE)
      else
        for torrent in torrents
          new Torrent(socky, @resultsContainer(), torrent, channel)

  @get '/', ->
    @toggleAbout(false)
    @floatSearchForm(true)
    $("#results, #loading").hide()
    $("#search input:text").focus()

  @post '#/subscribe', ->
    $.ajax(
      url: '/subscription'
      type: 'POST'
      data: { email: @params['email'] }
    ).done( ->
      alert "Subscription was successful! Thanks!"
      $("#subscribe input").val('')
    )
    false

  @get '#/about', ->
    @toggleAbout(true)

  @get '#/search', ->
    @toggleAbout(false)
    channelName = @guid()
    query = @params['query']

    if query.length == 0
      @redirect('/')
    else
      @floatSearchForm(false)
      @toggleResults(false)
      @toggleLoading(true)

      $("#search input").val(query).change()

      channel = socky.subscribe(channelName)
      $.get '/search', query: query, channel: channelName, (data) =>
        if data.success && data.torrents
          @fillWithResults(data.torrents, channelName)

      channel.bind "torrents", (torrents) =>
        @fillWithResults(torrents, channelName)

  @get /#.*/, -> @redirect('/')

