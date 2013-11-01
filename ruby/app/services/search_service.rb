class SearchService
  extend RedisCache

  def self.search(query, channel)
    torrents = cached_torrents_for_query(query)
    if torrents
      augment_torrents_with_torrent_url_or_start_job!(torrents, channel)
    else
      Resque.enqueue(FetchResultsJob, query, channel)
      nil
    end
  end
end
