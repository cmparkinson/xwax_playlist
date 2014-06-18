module XwaxExport
  class Run
    def initialize(options)
      @options = options
      @parser = Parser.from_xml(options[:file])
    end

    def parse_options
      # If we've been passed a list of playlists, exclude the others
      @parser.intersect_playlists(@options[:playlists]) if @options[:playlists].size > 0

      @parser.create_genre_playlists(@options[:ignored_genres]) if @options[:create_genre_playlists]
    end

    def write_playlists
      @parser.playlists.each do |name, p|
        # Prune the playlists before writing them out
        p.prune_by_rating(@options[:min_rating])

        p.write(@options[:playlist_dir])
      end
    end
  end

  module_function

  def run
    options = CommandLineParser.parse(ARGV)
    execute(options)
  end

  def execute(options)
    o = Run.new(options)
    o.parse_options
    o.write_playlists
  end
end