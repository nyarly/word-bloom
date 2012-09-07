# -*- coding: utf-8 -*-

require 'word-bloom/scorer'

describe WordBloom::Scorer do
  let :scorer do
    described_class.loaded_with(:all)
  end

  it "should recognize dutch" do
    scorer.language("Als hadden geweest is, is hebben te laat.").should == :dutch
  end

  it "should recognize french" do
     scorer.language("Bonjour, je m'appelle Sandrine. Voila ma chatte.").should == :french
  end

  it "should recognize spanish" do
     scorer.language("La palabra mezquita se usa en español para referirse a todo tipo de edificios dedicados.").should == :spanish
  end

  it "should recognize swedish" do
    scorer.language("Den spanska räven rev en annan räv alldeles lagom.").should == :swedish
  end

  it "should recognize russian" do
     scorer.language("Все новости в хронологическом порядке").should == :russian
  end

  it "should recognize italian" do
     scorer.language("Roma, capitale dell'impero romano, è stata per secoli il centro politico e culturale della civiltà occidentale.").should == :italian
  end

  it "should return nil for empty strings" do
    scorer.language("").should be_nil
  end

  it "should return some language for non empty strings" do
    scorer.language("test").should_not be_nil
  end

  it "should return a hash of language scores" do
    scorer.process_text("this is a test").should be_a_kind_of(Hash)
  end

end
