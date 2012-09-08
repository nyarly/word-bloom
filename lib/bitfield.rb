#        NAME: BitField
#      AUTHOR: Peter Cooper
#     LICENSE: MIT ( http://www.opensource.org/licenses/mit-license.php )
#   COPYRIGHT: (c) 2007 Peter Cooper (http://www.petercooper.co.uk/)

class BitField
  attr_reader :size
  attr_accessor :field
  include Enumerable

  ELEMENT_WIDTH = 32

  def initialize(size)
    @size = size
    @field = Array.new(((size - 1) / ELEMENT_WIDTH) + 1, 0)
  end

  # Set a bit (1/0)
  def []=(position, value)
    value == 1 ? @field[position / ELEMENT_WIDTH] |= 1 << (position % ELEMENT_WIDTH) : @field[position / ELEMENT_WIDTH] ^= 1 << (position % ELEMENT_WIDTH)
  end

  # Read a bit (1/0)
  def [](position)
    @field[position / ELEMENT_WIDTH] & 1 << (position % ELEMENT_WIDTH) > 0 ? 1 : 0
  end

  # Iterate over each bit
  def each(&block)
    @size.times { |position| yield self[position] }
  end

  # Returns the field as a string like "0101010100111100," etc.
  def to_s
    inject("") { |a, b| a + b.to_s }
  end

  # Returns the bitwise intersection with another BitField - pads smaller with
  # 0s
  def &(other)
    if self.size < other.size
      return other & self
    end

    skip =  self.size - other.size
    result = BitField.new(self.size)
    prefix = [0] * skip
    rest = (self.field[skip..-1]).zip(other.field).map do |left, right|
      left & right
    end
    result.field = prefix + rest
    return result
  end

  # Returns the total number of bits that are set
  # (The technique used here is about 6 times faster than using each or inject direct on the bitfield)
  def total_set
    @field.inject(0) { |a, byte| a += byte & 1 and byte >>= 1 until byte == 0; a }
  end
end
