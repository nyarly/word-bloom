require 'word-bloom'

class WordBloom
  class Scorer
    @@filters = {}
    @@all_languages = nil

    def self.load_filter(name)
      @@filters[name] ||=
        begin
          File.open(File.join(LANGUAGE_DIR_PATH, "#{name}.lang"), 'rb') do |file|
            BloominSimple.from_dump(file.read, &HASHER)
          end
        end
    end

    def self.all_languages
      @@all_languages ||= Dir.entries(LANGUAGE_DIR_PATH).grep(/\.lang$/).map do |filename|
        filename.sub(/\.lang$/,'').to_sym
      end
    end

    def self.loaded_with(*languages)
      scorer = self.new
      if [:all] == languages
        scorer.add_all_languages
      else
        languages.each do |language|
          scorer.add_language(language)
        end
      end
      return scorer
    end

    def initialize()
      @languages = {}
      @language_weights = Hash.new(1.0)
    end

    def add_language(name, weight = nil)
      self.class.load_filter(name)
      @languages[name] = true
      @language_weights[name] = weight unless weight.nil?
    end

    def add_all_languages
      self.class.all_languages.each do |language|
        add_language(language)
      end
    end

    def confidence(considered, results)
      top_results = results.values.sort
      best = top_results[-1]
      rest = top_results[0..-2].inject{|number, sum| sum + number}
      p({best: best, rest: rest})

      return OPTIMISM * best - rest
    end

    OPTIMISM = 3.5
    MIN_CONFIDENCE = 15

    # Very inefficient method for now.. but still beats the non-Bloom
    # alternatives.
    # Change to better bit comparison technique later..
    def process_text(text)
      results = Hash.new(0)
      word_count = 0
      text.split(/\s+/).each do |word|
        word = word.downcase
        next if /^\d*$/ =~ word
        @languages.keys.each do |lang|
          if @@filters[lang].includes?(word)
            p word if lang == :spanish
            results[lang] += 1
          end
        end

        # Every now and then check to see if we have a really convincing result.. if so, exit early.
        if word_count % 4 == 0 && results.size > 1
          #break if confidence(word_count + 1, results) > MIN_CONFIDENCE
        end

        word_count += 1
        #break if word_count > 100
      end
      results
    rescue => ex
      p ex, ex.backtrace
      nil
    end

    def language(text)
      process_text(text).max { |a,b| a[1] <=> b[1] }.first rescue nil
    end
  end
end
