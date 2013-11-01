class @Torrent

  template: """
    <td class='title'><a href='{{data.url}}' target="_blank">{{data.title}}</a></td>
    <td class='size'>{{data.size}}</td>
    <td class='seeds'>{{data.seeds}}</td>
    <td class='peers'>{{data.peers}}</td>
    <td class='download'>
      {{#torrentUrl}}
        <a href='{{torrentUrl}}' target='_blank'>Download!</a>
      {{/torrentUrl}}
      {{^torrentUrl}}
        {{^showProgress}}
          Searching...
        {{/showProgress}}
        {{#showProgress}}
          <span class='progress'>
            <span class='bar' style='width:{{percent}}'></span>
          </span>
        {{/showProgress}}
      {{/torrentUrl}}
    </td>
  """

  constructor: (@socky, @$parent, @data, channel) ->
    @channelName = "#{channel}-#{@data.hash.substring(0, 13)}"
    @render()
    unless @data.torrent_url
      @channel = @socky.subscribe(@channelName)
      @bind()

  bind: ->
    @channel.bind "progress", (progress) =>
      { todo: @todo, done: @done } = progress
      @render()

    @channel.bind "torrent", (url) =>
      @data.torrent_url = url
      @render()

  percent: -> "#{@done / @todo * 100}%"
  showProgress: -> @done > 1 && @todo > 1
  torrentUrl: -> @data.torrent_url

  render: ->
    @$dom ||= $("<tr/>").appendTo(@$parent)
    @$dom.empty().html Mustache.render(@template, @)

