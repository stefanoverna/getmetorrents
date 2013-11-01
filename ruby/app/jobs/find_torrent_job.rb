require 'nanny'

module FindTorrentJob
  @queue = :find

  extend RedisCache

  def self.perform(url, hash, channel)
    torrent = Nanny::Torrent.new(url: url, hash: hash)
    progress = Nanny::Progress.new do |p|
      $socky.trigger('progress', channel: channel, data: { todo: p.total_todo, done: p.total_done })
    end
    torrent_url = torrent.torrent_url(progress)
    cache_torrent_url(hash, torrent_url)
    $socky.trigger('torrent', channel: channel, data: torrent_url)

  rescue Nanny::Torrent::URLNotFound
    cache_torrent_url(hash, '')
    $socky.trigger('torrent', channel: channel, data: '')
  end

end
