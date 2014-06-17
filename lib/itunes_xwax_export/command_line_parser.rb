module XwaxExport
  class CommandLineParser
    def self.parse(args)
      options = OpenStruct.new

      options.ignored_genres = []
      options.playlists = []
      options.create_genre_playlists = true
      options.playlist_dir = ENV['PWD']
      options.min_rating = 0

      # TODO Add a music directory option to allow XML parsing from a different filesystem (ie an HFS filesystem shared between OSX and Linux)
      opts = OptionParser.new do |o|
        o.banner = "Usage: #{$0} [options] file"

        o.on('-c', '--copy DIR', 'Copy matching files to DIR') do |dir|
          options.copy_dir = dir
        end

        o.on('-C', '--copy-pattern PATTERN', 'Use PATTERN for naming the copied files') do |pattern|
          options.copy_pattern = pattern
        end

        o.on('-n', '--no-genre-playlists', 'Do not create a playlist for each genre') do
          options.create_genre_playlists = false
        end

        o.on('-i', '--include-playlist PLAYLIST', 'Include PLAYLIST in the output') do |playlist|
          options.playlists << playlist
        end

        o.on('-I', '--ignore-genre GENRE', 'Ignore GENRE when creating genre specific playlists') do |genre|
          options.ignored_genres << genre
        end

        o.on('-p', '--playlist DIR', 'Create playlist files in DIR') do |dir|
          options.playlist_dir = dir
        end

        o.on('-r', '--rating RATING', 'Only include files with a rating of RATING or higher (0-5)') do |rating|
          options.min_rating = rating
        end

        o.on_tail('-h', '--help', 'Show this message') do
          puts o
          exit
        end
      end

      opts.parse!(args)

      # Expect the remaining argument to be the XML file.
      options.file = args[0]
      unless options.file and File.exist?(options.file)
        puts opts
        exit 1
      end

      options
    end
  end
end