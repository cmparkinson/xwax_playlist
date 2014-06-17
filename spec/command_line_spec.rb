describe 'CommandLineParser' do
  before do
    $stdout.stub(:write)
    $stderr.stub(:write)
  end

  let(:empty) { [] }
  let(:missing_file) { ['missing_file.321.no'] }
  let(:this_file) { [ __FILE__ ] }
  let(:copy_dir) { [ '-c', '/tmp', __FILE__ ] }
  let(:copy_pattern) { [ '-C', '%{file}', __FILE__ ] }
  let(:no_genre) { [ '-n', __FILE__ ] }
  let(:playlists) { [ '-i', 'Test Playlist', '-i', 'Empty Playlist', __FILE__ ] }
  let(:ignored_genres) { [ '-I', 'Ignored1', '-I', 'Ignored2', __FILE__ ] }
  let(:playlist_dir) { [ '-p', '/tmp', __FILE__ ] }
  let(:min_rating) { [ '-r', '5', __FILE__ ] }
  let(:bad_min_rating) { [ '-r', 'S', __FILE__] }

  it 'fails with no file' do
    options = XwaxExport::CommandLineParser.parse(empty)
    expect(options).to eq(false)
  end

  it 'fails with a missing file' do
    options = XwaxExport::CommandLineParser.parse(missing_file)
    expect(options).to eq(false)
  end

  it 'succeeds with an existent file' do
    options = XwaxExport::CommandLineParser.parse(this_file)
    expect(options).not_to eq(false)
  end

  it 'captures the copy dir switch' do
    options = XwaxExport::CommandLineParser.parse(copy_dir.clone)
    expect(options.copy_dir).to eq(copy_dir[1])
  end

  it 'captures the copy pattern switch' do
    options = XwaxExport::CommandLineParser.parse(copy_pattern.clone)
    expect(options.copy_pattern).to eq(copy_pattern[1])
  end

  it 'captures the no genre playlists switch' do
    options = XwaxExport::CommandLineParser.parse(no_genre.clone)
    expect(options.create_genre_playlists).to eq(false)
  end

  it 'captures the playlists switch' do
    options = XwaxExport::CommandLineParser.parse(playlists.clone)
    expect(options.playlists).to eq([playlists[1], playlists[3]])
  end

  it 'captures the ignored genres switch' do
    options = XwaxExport::CommandLineParser.parse(ignored_genres.clone)
    expect(options.ignored_genres).to eq([ignored_genres[1], ignored_genres[3]])
  end

  it 'captures the playlist directory switch' do
    options = XwaxExport::CommandLineParser.parse(playlist_dir.clone)
    expect(options.playlist_dir).to eq(playlist_dir[1])
  end

  it 'captures the min rating switch' do
    options = XwaxExport::CommandLineParser.parse(min_rating.clone)
    expect(options.min_rating).to eq(5)
  end

  it 'fails with a non-integer passed to the min rating switch' do
    expect{XwaxExport::CommandLineParser.parse(bad_min_rating.clone)}.to raise_error(OptionParser::InvalidArgument)
  end
end