require 'nanny'

module FetchResultsJob
  @queue = :fetch

  extend RedisCache

  def self.perform(query, channel)
    torrents = Nanny::Search.new.search_torrents(query)[0 .. 5]
    torrents.map! { |t| to_json(t) }
    cache_torrents_for_query(query, torrents)
    augment_torrents_with_torrent_url_or_start_job!(torrents, channel)
    $socky.trigger('torrents', channel: channel, data: torrents)
  end

  def self.to_json(t)
    {
      'title' => t.title,
      'url'   => t.url,
      'seeds' => t.seeds,
      'peers' => t.peers,
      'size'  => t.human_size,
      'hash'  => t.hash
    }
  end

end
