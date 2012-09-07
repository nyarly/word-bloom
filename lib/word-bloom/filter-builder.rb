class WordBloom
  class FilterBuilder
    BITFIELD_WIDTH = 2_000_000

    def initialize(source_path)
      @filename = source_path
    end

    def filter_from_dictionary
      filter = BloominSimple.new(BITFIELD_WIDTH, &HASHER)
      File.open(@filename).each { |word| filter.add(word) }
      filter
    end
  end
end
