module XwaxExport
  class Playlist
    attr_accessor :tracks

    IGNORED = [
        'Library',
        'Music',
        'Movies',
        'TV Shows',
        '90\’s Music',
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

    def write(dir, min_rating = 0)
      File.open(File.join(dir, @name), 'w') do |f|
        @tracks.each do |track|
          f.puts("#{track.location}\t#{track.artist}\t#{track.title}") if track.min_rating >= min_rating
        end
      end
    end
  end
end