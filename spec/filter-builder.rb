require 'word-bloom'
require 'word-bloom/filter-builder'

describe WordBloom::FilterBuilder do
  it "should ingest pinyin" do
    builder = WordBloom::FilterBuilder.new(File::expand_path("../../wordlists/pinyin", __FILE__))
    filter = builder.filter_from_dictionary
    filter.should be_an_instance_of(BloominSimple)
  end

  it "should ingest italian" do
    builder = WordBloom::FilterBuilder.new(File::expand_path("../../wordlists/italian", __FILE__))
    filter = builder.filter_from_dictionary
    filter.should be_an_instance_of(BloominSimple)
  end
end
