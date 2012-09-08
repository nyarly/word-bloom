#        NAME: BloominSimple
#      AUTHOR: Peter Cooper
#     LICENSE: MIT ( http://www.opensource.org/licenses/mit-license.php )
#   COPYRIGHT: (c) 2007 Peter Cooper

require 'bitfield'

class BloominSimple
  attr_accessor :bitfield, :hasher

  def initialize(bitsize, &block)
    @bitfield = BitField.new(bitsize)
    @size = bitsize
    @hasher = block || lambda do |word|
      word = word.downcase.strip
      [h1 = word.sum, h2 = word.hash, h2 + h1 ** 3]
    end
  end

  # Add item to the filter
  def add(item)
    @hasher[item].each { |hi| @bitfield[hi % @size] = 1 }
  end

  # Find out if the filter possibly contains the supplied item
  def includes?(item)
    @hasher[item].each { |hi| return false unless @bitfield[hi % @size] == 1 } and true
  end

  # Allows comparison between two filters. Returns number of same bits.
  def &(other)
    raise "Wrong sizes" if self.bitfield.size != other.bitfield.size
    return (self.bitfield & other.bitfield).total_set
  end

  # Dumps the bitfield for a bloom filter for storage
  def dump
    [@size, *@bitfield.field].pack("I*")
  end

  # Creates a new bloom filter object from a stored dump (hasher has to be resent though for additions)
  def self.from_dump(data, &block)
    data = data.unpack("I*")
    temp = new(data[0], &block)
    temp.bitfield.field = data[1..-1]
    temp
  end
end
