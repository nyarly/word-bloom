require 'corundum'
require 'corundum/tasklibs'

module Corundum
  tk = Toolkit.new do |tk|
  end

  tk.in_namespace do
    sanity = GemspecSanity.new(tk)
    rspec = RSpec.new(tk)
    cov = SimpleCov.new(tk, rspec) do |cov|
      cov.threshold = 70
    end
    gem = GemBuilding.new(tk)
    cutter = GemCutter.new(tk,gem)
    email = Email.new(tk)
    vc = Git.new(tk) do |vc|
      vc.branch = "master"
    end
    task tk.finished_files.build => vc["is_checked_in"]
    yd = YARDoc.new(tk)

    docs = DocumentationAssembly.new(tk, yd, rspec, cov)

    pages = GithubPages.new(docs)
  end
end

task :deploy => [:release, :publish_docs]

rule(%r{^lang/.*\.lang} => [ proc do |path|
  path.sub(%r{^lang/(.*).lang$}, "wordlists/\1")
end]) do |task|
  require 'lib/word-bloom'
  puts "Doing #{lang}"
  filter = WhatBloom.filter_from_dictionary(task.source)
  File.open(task.name, 'wb') { |f| f.write filter.dump }
end

namespace :filters do
  desc "Use this to build new filters (for other languages, ideally) from /usr/share/dict/words style dictionaries.."
  task :ingest_dictionary, [:source, :target] do |task, args|
    require 'lib/word-bloom'
    filter = WordBloom.filter_from_dictionary(args[:source])
    File.open(args[:target], 'wb') { |f| f.write filter.dump }
  end

  desc "Build dictionaries for wordlists"
  task :build => %w{lang/pinyin.lang lang/dutch.lang lang/french.lang lang/swedish.lang lang/russian.lang lang/german.lang lang/farsi.lang lang/italian.lang lang/portuguese.lang lang/english.lang lang/spanish.lang}
end
