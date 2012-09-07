require 'bloominsimple'
require 'digest/sha1'

class WordBloom
  HASHER = lambda { |item| Digest::SHA1.digest(item.downcase.strip).unpack("VV") }
  LANGUAGE_DIR_PATH = File.expand_path("../../lang", __FILE__)
end
