$:.unshift(File.expand_path(__dir__))

require 'plist'
require 'optparse'
require 'ostruct'

require 'itunes_xwax_export/playlist'
require 'itunes_xwax_export/track'
require 'itunes_xwax_export/parser'
require 'itunes_xwax_export/command_line_parser'

module XwaxExport
  VERSION = '0.1.0'
end
