describe 'Library' do
  before(:all) do
    @plist = update_path(File.join('spec', 'itunes', 'iTunes Library.xml'))
    @parser = XwaxExport::Parser.new(@plist)
    @tmp_dir = Dir.mktmpdir
  end

  after(:all) do
    FileUtils.remove_entry(@tmp_dir)
  end

  describe 'Track' do
    subject(:track) { XwaxExport::Track.new(@plist['Tracks'].first[1]) }

    describe '#copy' do
      let(:bad_dir) { 'invalid_directory_name' }
      let(:tmp_dir) { @tmp_dir }
      let(:dst_filename) { File.join(@tmp_dir, File.basename(subject.path)) }
      let(:dst_uri) { URI::Generic.build({scheme: 'file', host: 'localhost', path: Addressable::URI.escape(dst_filename)}) }

      it 'will fail if the directory doesn\'t exist' do
        expect { subject.copy(bad_dir) }.to raise_error
      end

      it 'will succeed if the directory exists' do
        subject.copy(tmp_dir)
        expect(File.exist?(dst_filename)).to eq(true)
        expect(subject.location).to eq(dst_uri.to_s)
        expect(subject.path).to eq(dst_filename)
        FileUtils.rm dst_filename
      end

      it 'will rename the file if there is a conflict' do
        filename = 'Empty Song.mp3'

        ext = File.extname(filename)
        name = File.basename(filename, ext)
        renamed = File.join(tmp_dir, "#{name}_1#{ext}")

        path = File.join(tmp_dir, filename)

        FileUtils.touch(path)

        subject.copy(tmp_dir, '%{title}.mp3')
        expect(File.exist?(renamed)).to eq(true)

        FileUtils.rm path
        FileUtils.rm renamed
      end
    end

    describe '#evaluate_pattern' do
      let(:pattern) { '%{genre} - %{artist} - %{title}.mp3' }
      let(:correct) { 'Progressive House - Empty Artist - Empty Song.mp3' }

      it 'evaluates to the correct pattern' do
        expect(subject.evaluate_pattern(pattern)).to eq(correct)
      end
    end
  end

  describe 'Playlist' do
    let(:playlists) { XwaxExport::Playlist.load_from_plist(@plist['Playlists']) }

    describe 'Empty playlist' do
      it 'contains no tracks' do
        expect(playlists['Empty Playlist'].tracks.size).to eq(0)
      end
    end

    describe 'Test playlist' do
      it 'contains one track' do
        expect(playlists['Test Playlist'].tracks.size).to eq(1)
      end
    end
  end

  describe 'Parser' do
    let(:parser) { XwaxExport::Parser.new(@plist) }

    it 'will intersect the playlist hash with an array of playlist names' do
      playlist_name = 'Test Playlist'
      playlist = @parser.playlists[playlist_name]
      expect(@parser.intersect_playlists([playlist_name]).values).to eq([playlist])
    end
  end

  describe 'Genre playlist' do
    subject { @parser.create_genre_playlists['Progressive House'] }
    describe 'Progressive house' do
      it 'contains one track' do
        expect(subject.tracks.size).to eq(1)
      end
    end
  end
end
