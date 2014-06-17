require 'pathname'

def update_path(xml_file)
  plist = Plist.parse_xml(xml_file)
  music_folder_path = Addressable::URI.unescape(URI(plist['Music Folder']).path)
  track_path = Addressable::URI.unescape(URI(plist['Tracks'].first[1]['Location']).path)
  relative_path = Pathname.new(track_path).relative_path_from(Pathname.new(music_folder_path))

  new_music_folder_path = File.join(File.dirname(File.realpath(xml_file)), 'iTunes Media', File::SEPARATOR)
  new_track_path = File.join(new_music_folder_path, relative_path)

  plist['Music Folder'] = URI::Generic.build({
      scheme: 'file',
      host: 'localhost',
      path: Addressable::URI.escape(new_music_folder_path)
  }).to_s

  plist['Tracks'].first[1]['Location'] = URI::Generic.build({
      scheme: 'file',
      host: 'localhost',
      path: Addressable::URI.escape(new_track_path)
  }).to_s

  plist
end