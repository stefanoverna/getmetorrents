class @App
  NO_RESULTS_TEMPLATE = '<tr><td colspan="5" class="no-results">No results found!</td></tr>'

  toggleResults: (toggle) ->
    $("#results").toggle(toggle)
    @resultsContainer().empty()
  toggleSearchForm: (toggle) ->
    $("#search").toggle(toggle)
  toggleLoading: (toggle) ->
    $("#loading").toggle(toggle)
  floatSearchForm: (toggle) ->
    $("#search").toggleClass('floating', toggle)
  resultsContainer: ->
    $("#results tbody")

  run: ->
    $("#app").show()
    @floatSearchForm(true)
    $("#results, #loading").hide()
    $("#search input:text").focus().autogrow()
    $("#search").submit =>
      @search($("#search input").val())
      false

  search: (query) ->
    @floatSearchForm(false)
    @toggleResults(false)
    @toggleLoading(true)

    new Nanny.Search().searchTorrents query, (err, torrents) =>
      @toggleResults(true)
      @toggleLoading(false)
      if err
        alert 'Error'
      else
        if torrents.length == 0
          @resultsContainer().empty().html(NO_RESULTS_TEMPLATE)
        else
          views = for torrent in torrents
            new TorrentView(@resultsContainer(), torrent)

          worker = (view, callback) ->
            view.setState("Searching...")
            view.torrent.getTorrentUrl (err, url) ->
              if err
                view.setState("Failed!")
                callback(null, null)
              else
                view.setUrl(url)
                callback(null, null)

          q = async.queue(worker, 5)
          q.push(views)

