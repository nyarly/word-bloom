
require 'bloominsimple'
require 'digest/sha1'

class WordBloom
  HASHER = lambda { |item| Digest::SHA1.digest(item.encode('UTF-8', :invalid => :replace).downcase.strip).unpack("VV") }
  LANGUAGE_DIR_PATH = File.expand_path("../../lang", __FILE__)
end
