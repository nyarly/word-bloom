Gem::Specification.new do |spec|
  spec.name		= "word-bloom"
  spec.version		= "0.1"
  author_list = {
    "Peter Cooper" => "",
    "Judson Lester" => "nyarly@gmail.com"
  }
  spec.authors		= author_list.keys
  spec.email		= spec.authors.map {|name| author_list[name]}
  spec.summary		= "Natural language guessing for text samples"
  spec.description	= <<-EndDescription
  Guesses the natural language of a text sample based on bloom filter matches of words in the text.  Fast, reasonably accurate.
  EndDescription

  spec.rubyforge_project= spec.name.downcase
  spec.homepage        = "http://nyarly.github.com/word-bloom/"
  spec.required_rubygems_version = Gem::Requirement.new(">= 0") if spec.respond_to? :required_rubygems_version=

  # Do this: y$@"
  # !!find lib bin doc spec spec_help -not -regex '.*\.sw.' -type f 2>/dev/null
  spec.files		= %w[
    lib/bloominsimple.rb
    lib/word-bloom.rb
    lib/word-bloom/filter-builder.rb
    lib/word-bloom/scorer.rb
    lib/word-bloom/quality.rb
    lib/bitfield.rb
    lang/pinyin.lang
    lang/dutch.lang
    lang/french.lang
    lang/swedish.lang
    lang/russian.lang
    lang/german.lang
    lang/farsi.lang
    lang/italian.lang
    lang/portuguese.lang
    lang/english.lang
    lang/spanish.lang
  ]

  spec.licenses = ["MIT"]
  spec.require_paths = %w[lib/]
  spec.rubygems_version = "1.3.5"

  if spec.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    spec.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      spec.add_development_dependency "corundum", "~> 0.0.1"
    else
      spec.add_development_dependency "corundum", "~> 0.0.1"
    end
  else
    spec.add_development_dependency "corundum", "~> 0.0.1"
  end

  spec.has_rdoc		= true
  spec.extra_rdoc_files = Dir.glob("doc/**/*")
  spec.rdoc_options	= %w{--inline-source }
  spec.rdoc_options	+= %w{--main doc/README }
  spec.rdoc_options	+= ["--title", "#{spec.name}-#{spec.version} RDoc"]

  spec.post_install_message = "Thanks again to Peter Cooper - JL"
end
