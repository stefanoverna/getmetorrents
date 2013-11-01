class @TorrentView

  template: """
    <td class='title'><a href='{{torrent.link}}' target="_blank">{{torrent.title}}</a></td>
    <td class='size'>{{torrent.humanSize}}</td>
    <td class='seeds'>{{torrent.seeds}}</td>
    <td class='peers'>{{torrent.peers}}</td>
    <td class='download'>
      {{#torrentUrl}}
        <a href='{{torrentUrl}}' target='_blank'>Download!</a>
      {{/torrentUrl}}
      {{^torrentUrl}}
        {{state}}
      {{/torrentUrl}}
    </td>
  """

  constructor: (@$parent, @torrent) ->
    @state = ""
    @render()

  render: ->
    @$dom ||= $("<tr/>").appendTo(@$parent)
    @$dom.empty().html Mustache.render(@template, @)

  setState: (state) ->
    @state = state
    @render()

  setUrl: (state) ->
    @torrentUrl = state
    @render()

