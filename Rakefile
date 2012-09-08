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
  match = %r{^lang/(.*).lang$}.match(path)
  "wordlists/#{match[1]}".tap{|dp| p dp}
end]) do |task|
  require 'word-bloom'
  require 'word-bloom/filter-builder'
  puts "Doing #{task.source} -> #{task.name}"
  builder = WordBloom::FilterBuilder.new(task.source)
  filter = builder.filter_from_dictionary
  File.open(task.name, 'wb') { |f| f.write filter.dump }
end

namespace :filters do
  desc "Use this to build new filters (for other languages, ideally) from /usr/share/dict/words style dictionaries.."
  task :ingest_dictionary, [:source, :target] do |task, args|
    require 'word-bloom'
    builder = WordBloom::FilterBuilder.new(args[:source])
    filter = builder.filter_from_dictionary
    File.open(args[:target], 'wb') { |f| f.write filter.dump }
  end

  desc "Quick check that the Bloom filters are at least fairly different"
  task :inspect do
    require 'word-bloom/quality'

    puts WordBloom::Quality.build_all
  end

  desc "Build dictionaries for wordlists"
  task :build => %w{lang/pinyin.lang lang/dutch.lang lang/french.lang lang/swedish.lang lang/russian.lang lang/german.lang lang/farsi.lang lang/italian.lang lang/portuguese.lang lang/english.lang lang/spanish.lang}
end

namespace :corpus do
  Dir.entries('spec_help/corpus').each do |language|
    next if /[.]+/ =~ language
    namespace language do
      desc "Pull in a webpage for corpus testing"
      task :collect, [:source] do |task, args|
        raise "Need a url" unless args[:source]

        require 'zlib'
        require 'excon'
        require 'nokogiri'

        uri = URI(args[:source])
        body = nil

        filename = [uri.host, uri.path.gsub(%r{/}, "-"), (uri.query||"").gsub("&", "-")].join("-")
        target_path = File.join('spec_help/corpus', language, filename)
        cookies = nil

        response = nil
        5.times do
          response = Excon.get(uri.to_s, :headers => {"Host" => uri.host, "Cookie" => cookies})
          case response.status
          when (200..299)
            break
          when (300..399)
            uri = URI(response.get_header('Location'))
          else
            raise "HTTP response: #{response}"
          end
        end

        case response.get_header('Content-Encoding')
        when "gzip"
          body = Zlib::GzipReader.new(StringIO.new(response.body)).read
        when "deflate"
          body = Zlib::Inflate.inflate(response.body)
        else
          body = response.body
        end

        doc = Nokogiri::HTML(body)
        doc.search('//script').each{|tag| tag.unlink}
        doc.search('//style').each{|tag| tag.unlink}

        content = doc.content

        File.open(target_path, 'w') do |file|
          file.write content
        end
        puts "Wrote #{content.length} bytes to #{target_path}"
      end
    end
  end
end
