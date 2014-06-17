module XwaxExport
  class Track
    @@id_map = {}

    def self.load_from_plist(plist)
      tracks = []
      plist.each { |id, track| tracks << new(track) }
      tracks
    end

    def self.get_by_id(id)
      @@id_map[id]
    end

    attr_accessor :id, :name, :artist, :genre, :location, :path, :rating, :year

    def initialize(properties)
      @id = properties['Track ID']
      @name = properties['Name']
      @artist = properties['Artist']
      @genre = properties['Genre']
      @rating = properties['Rating'] && properties['Rating'] / 20 || 0
      @year = properties['Year']
      @comments = properties['Comments']
      @location = properties['Location']
      @path = Addressable::URI.unescape(URI(@location).path)

      @copied = false

      @@id_map[@id] = self
    end

    def evaluate_pattern(pattern)
      pattern % build_attr_hash
    end

    def copy(dst_dir, pattern = nil)
      # Don't copy the file more than once.
      return false if @copied

      src = Addressable::URI.unescape(URI(@location).path)
      dst_filename = pattern && evaluate_pattern(pattern) || File.basename(src)

      FileUtils.cp(src, File.join(dst_dir, dst_filename))
      @copied = true

      # Update the location
      uri = URI::Generic.build({
          scheme: 'file',
          host: 'localhost',
          path: Addressable::URI.escape(File.absolute_path(dst_filename))
          })
      @location = uri.to_s
    end

    private

    def build_attr_hash
      {
          file: @location,
          title: @name,
          artist: @artist,
          genre: @genre,
          year: @year,
          rating: @rating,
          comments: @comments
      }
    end
  end
end