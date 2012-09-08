require 'bloominsimple'
require 'digest/sha1'

class WordBloom
  HASHER = lambda do |item|
    begin
      item = item.encode("UTF-16LE", :invalid => :replace, :undef => :replace, :replace => "").encode("UTF-8")
      Digest::SHA1.digest(item.downcase.strip).unpack("VV")
    rescue ArgumentError => ex
      p __ENCODING__
      p ex.message, item
      raise
    end
  end
  LANGUAGE_DIR_PATH = File.expand_path("../../lang", __FILE__)
end
