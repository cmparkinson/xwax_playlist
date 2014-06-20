describe 'Run' do
  TEST_PLAYLIST = 'Test Playlist'
  EMPTY_PLAYLIST = 'Empty Playlist'
  PROGRESSIVE_HOUSE = 'Progressive House'

  before(:each) do
    # Set up a temporary area
    @tmp_dir = Dir.mktmpdir
    options[:playlist_dir] = @tmp_dir
  end

  let(:options) do
    {
        file: File.join('spec', 'itunes', 'iTunes Library.xml'),
        min_rating: 0,
        playlists: [],
        create_genre_playlists: true,
        ignored_genres: [],
        stdout: false
    }
  end

  describe 'playlists' do
    it 'will create playlists that contain tracks' do
      XwaxPlaylist.execute(options)
      expect(File.exist?(File.join(@tmp_dir, TEST_PLAYLIST))).to eq(true)
    end

    it 'will not create empty playlists' do
      XwaxPlaylist.execute(options)
      expect(File.exist?(File.join(@tmp_dir, EMPTY_PLAYLIST))).to eq(false)
    end

    it 'will create genre playlists by default' do
      XwaxPlaylist.execute(options)
      expect(File.exist?(File.join(@tmp_dir, PROGRESSIVE_HOUSE))).to eq(true)
    end

    it 'will not create genre playlists when the -n switch is passed' do
      options[:create_genre_playlists] = false
      XwaxPlaylist.execute(options)
      expect(File.exist?(File.join(@tmp_dir, PROGRESSIVE_HOUSE))).to eq(false)
    end

    it 'will not create playlists for ignored genres' do
      options[:ignored_genres] << PROGRESSIVE_HOUSE
      XwaxPlaylist.execute(options)
      expect(File.exist?(File.join(@tmp_dir, PROGRESSIVE_HOUSE))).to eq(false)
    end

    it 'will not add tracks below the minimum rating' do
      options[:min_rating] = 5
      XwaxPlaylist.execute(options)
      expect(File.exist?(File.join(@tmp_dir, TEST_PLAYLIST))).to eq(false)
    end

    it 'will copy tracks using the specified naming pattern' do
      pattern = '%{artist} - %{title}.mp3'
      filename = 'Empty Artist - Empty Song.mp3'

      options[:copy_dir] = @tmp_dir
      options[:copy_pattern] = pattern
      XwaxPlaylist.execute(options, update_path(options[:file]))
      expect(File.exist?(File.join(@tmp_dir, filename))).to eq(true)
    end

    it 'will write to stdout when passed the -o switch' do
      playlist_name = 'Test Playlist'

      file_path = File.join(__dir__, 'itunes', 'iTunes Media', 'Music', 'Empty Artist', 'Unknown Album', 'Empty Song.mp3')
      expected_line = "#{file_path}\tEmpty Artist\tEmpty Song\n"
      options[:stdout] = true
      options[:playlists] << playlist_name

      begin
        out = $stdout
        buffer = StringIO.new
        $stdout = buffer

        XwaxPlaylist.execute(options, update_path(options[:file]))
        expect(buffer.string).to eq(expected_line)
      ensure
        $stdout = out
      end
    end

    after(:each) do
      FileUtils.rm_rf("#{@tmp_dir}/.", secure: true)
    end
  end

  after(:each) do
    FileUtils.remove_entry(@tmp_dir)
  end
end