describe 'Library' do
  before(:all) do
    @plist = update_path(File.join('spec', 'itunes', 'iTunes Library.xml'))
    @parser = XwaxExport::Parser.new(@plist)
  end

  describe 'Track' do
    subject(:track) { XwaxExport::Track.new(@plist['Tracks'].first[1]) }

    describe '#copy' do
      let(:bad_dir) { '/tmp/invalid_directory' }
      let(:good_dir) { '/tmp/' }
      let(:dst_filename) { File.join(good_dir, File.basename(subject.path)) }
      let(:dst_uri) { URI::Generic.build({scheme: 'file', host: 'localhost', path: Addressable::URI.escape(dst_filename)}) }

      it 'fails if the directory doesn\'t exist' do
        expect { subject.copy(bad_dir) }.to raise_error
      end

      it 'succeeds otherwise' do
        subject.copy(good_dir)
        expect(File.exist?(dst_filename)).to eq(true)
        expect(subject.location).to eq(dst_uri.to_s)
        expect(subject.path).to eq(dst_filename)
        FileUtils.rm dst_filename
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

  describe 'Genre playlist' do
    subject { @parser.create_genre_playlists['Progressive House'] }
    describe 'Progressive house' do
      it 'contains one track' do
        expect(subject.tracks.size).to eq(1)
      end
    end
  end
end
