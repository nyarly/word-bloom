require 'word-bloom/scorer'

class WordBloom
  class Quality
    def self.build_all
      qual = self.new
      qual.languages = Scorer::all_languages
      qual.build_metrics
      qual
    end

    def initialize
      @correlations = {}
      @languages = []
    end

    attr_accessor :languages
    attr_reader :correlations

    def build_metrics
      require 'word-bloom/filter-builder'

      languages.each do |lang|
        Scorer::load_filter(lang)
      end

      languages.each_with_index do |lang, index|
        languages.drop(index + 1).each do |other_lang|
          @correlations[[lang, other_lang]] =
            (Scorer::filter_for(lang) & Scorer::filter_for(other_lang)).to_f / FilterBuilder::BITFIELD_WIDTH
        end
      end
    end

    def to_s
      width = languages.map{|lang| lang.to_s.length}.max + 2
      col_sep = "  "
      ([([" " * width] + languages.map{|lang| lang.to_s.rjust(width)}).join(col_sep)] +
      languages.map do |left|
        ([left.to_s.ljust(width)] +
          languages.map do |right|
          if num = @correlations[[left, right]] || @correlations[[right, left]]
            "%#{width}f" % num
          else
            "-" * width
          end
          end
        ).join(col_sep)
      end).join("\n")
    end
  end
end
