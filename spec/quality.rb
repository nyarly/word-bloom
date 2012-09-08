require 'word-bloom/quality'

describe WordBloom::Quality do
  it "should produce a hash" do
    qual = described_class.new
    qual.languages = [:english, :pinyin]
    qual.build_metrics
    qual.correlations.should be_an_instance_of(Hash)
    qual.correlations[[:english, :pinyin]].should_not be_nil
  end
end
