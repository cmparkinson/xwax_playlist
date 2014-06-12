module XwaxExport
  class CommandLineParser
    def self.parse(args)
      options = OpenStruct.new

      options.ignored_genres = []
      options.create_genre_playlists = true
      options.out_dir = ENV['PWD']

      opts = OptionParser.new do |o|
        o.banner = "Usage: #{$0} [options] file"

        o.on('-n', '--no-genre-playlists', 'Do not create a playlist for each genre') do
          options.create_genre_playlists = false
        end

        o.on('-i', '--ignore-genre GENRE', 'Ignore GENRE when creating genre specific playlists') do |genre|
          options.ignored_genres << genre
        end
        o.on('-o', '--out OUT', 'Create playlist files in OUT') do |dir|
          options.out_dir = dir
        end

        o.on_tail('-h', '--help', 'Show this message') do
          puts o
          exit
        end
      end

      opts.parse!(args)
      options
    end
  end
end