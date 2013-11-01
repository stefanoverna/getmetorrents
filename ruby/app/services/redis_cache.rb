require 'json'

module RedisCache

  def redis
    $redis
  end

  def gen_key(*keys)
    keys.unshift("web").join(":")
  end

  def get_cache(*keys)
    redis.get gen_key(keys)
  end

  def set_cache(*keys, value)
    redis.setex gen_key(keys), 3600 * 24, value
  end

  def cached_torrents_for_query(query)
    val = get_cache("search-torrents", normalize_query(query))
    if val
      JSON.parse(val)
    else
      nil
    end
  end

  def cache_torrents_for_query(query, torrents)
    set_cache("search-torrents", normalize_query(query), JSON.generate(torrents))
  end

  def cached_torrent_url(hash)
    get_cache("torrent-url", hash.upcase)
  end

  def cache_torrent_url(hash, url)
    set_cache("torrent-url", hash.upcase, url)
  end

  def augment_torrents_with_torrent_url_or_start_job!(torrents, channel)
    torrents.each do |torrent|
      url = cached_torrent_url(torrent['hash'])
      if url
        torrent['torrent_url'] = url
      else
        Resque.enqueue(FindTorrentJob, torrent['url'], torrent['hash'], "#{channel}-#{torrent['hash'][0...13]}")
      end
    end
  end

  def normalize_query(query)
    query.downcase.gsub(/\s+/, ' ').strip
  end

end
