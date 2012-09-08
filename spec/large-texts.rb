describe "Texts loaded from fixtures" do
  let :scorer do
    WordBloom::Scorer.loaded_with(:all)
  end

  corpus_path = File.expand_path("../../spec_help/corpus/", __FILE__)

  Dir.entries(corpus_path).each do |language|
    next if /^[.]+$/ =~ language
    Dir.entries(File.join(corpus_path, language)).each do |file|
      next if /^[.]+$/ =~ file
      describe file do
        let :full_path do
          File.join(corpus_path, language, file)
        end

        let :full_text do
          File.read(full_path)
        end

        it "should match as #{language}" do
          scorer.language(full_text).should == language.to_sym
        end
      end
    end
  end
end
