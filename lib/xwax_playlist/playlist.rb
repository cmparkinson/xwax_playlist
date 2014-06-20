module XwaxPlaylist
  class Playlist
    attr_accessor :tracks

    IGNORED = [
        'Genius',
        'Library',
        'Music',
        'Movies',
        'TV Shows',
        '90’s Music',
        'Classical Music',
        'My Top Rated',
        'Recently Added',
        'Recently Played',
        'Top 25 Most Played'
    ]

    def self.load_from_plist(plist)
      lists = {}

      plist.each do |plist_entry|
        name = plist_entry['Name']
        next if IGNORED.include?(name)

        playlist = new(name)
        lists[name] = playlist

        if plist_entry['Playlist Items']
          plist_entry['Playlist Items'].each do |t|
            track = Track.get_by_id(t['Track ID'])
            playlist << track if track
          end
        end
      end

      lists
    end

    def initialize(name)
      @name = name
      @tracks = []
    end

    def <<(track)
      @tracks << track
    end

    def prune_by_rating(rating)
      @tracks.delete_if { |t| t.rating < rating }
    end

    def write_to_file(dir)
      # Don't write empty playlists
      return false if @tracks.size == 0

      tracks = 0
      File.open(File.join(dir, @name), 'w') do |f|
        tracks = write(f)
      end

      tracks
    end

    def write(io)
      # Don't write empty playlists
      return false if @tracks.size == 0

      track_count = 0
      @tracks.each do |track|
        track_count += 1
        io.puts("#{track.path}\t#{track.artist}\t#{track.title}")
      end

      track_count
    end
  end
end