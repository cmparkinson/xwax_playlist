module XwaxExport
  class Track
    @@id_map = {}

    def self.load_from_plist(plist)
      @tracks = []
      plist.each { |id, track| @tracks << new(track) }
    end

    def self.get_by_id(id)
      @@id_map[id]
    end

    attr_accessor :id, :name, :artist, :genre, :location

    def initialize(properties)
      @id = properties['Track ID']
      @name = properties['Name']
      @artist = properties['Artist']
      @genre = properties['Genre']
      @location = properties['Location']
      @rating = properties['Rating'] || 0

      @@id_map[@id] = self
    end
  end
end