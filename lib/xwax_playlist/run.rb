module XwaxPlaylist
  class Run
    def initialize(options, xml = nil)
      @options = options
      if xml
        @parser = Parser.new(xml)
      else
        @parser = Parser.from_xml(options[:file])
      end
    end

    def parse_options
      @parser.create_genre_playlists(@options[:ignored_genres]) if @options[:create_genre_playlists]

      # If we've been passed a list of playlists, exclude the others
      @parser.intersect_playlists(@options[:playlists]) if @options[:playlists].size > 0

      if @options[:min_rating] > 0
        @parser.playlists.each do |name, p|
          p.prune_by_rating(@options[:min_rating])
        end
      end
    end

    def write
      @parser.playlists.each do |name, p|
        p.tracks.each { |t| t.copy(@options[:copy_dir], @options[:copy_pattern]) } if @options[:copy_dir]

        if @options[:stdout]
          p.write($stdout)
        else
          p.write_to_file(@options[:playlist_dir])
        end
      end
    end
  end

  module_function

  def run
    options = CommandLineParser.parse(ARGV)
    exit 1 unless options
    execute(options)
  end

  def execute(options, xml = nil)
    o = Run.new(options, xml)
    o.parse_options
    o.write
  end
end