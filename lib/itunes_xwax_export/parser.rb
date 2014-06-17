module XwaxExport
  class Parser
    attr_accessor :tracks, :playlists

    def initialize(xml_file)
      plist = Plist::parse_xml(xml_file)

      @tracks = Track.load_from_plist(plist['Tracks'])
      @playlists = Playlist.load_from_plist(plist['Playlists'])
    end

    def build_genre_playlists(ignored)
      playlists = {}

      @tracks.each do |t|
        next if ignored.include?(t.genre)

        playlists[t.genre] ||= Playlist.new(t.genre)
        playlists[t.genre] << t
      end

      playlists
    end
  end
end