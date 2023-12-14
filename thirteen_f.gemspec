require_relative 'lib/thirteen_f/version'

Gem::Specification.new do |spec|
  spec.name          = "thirteen_f"
  spec.version       = ThirteenF::VERSION
  spec.authors       = ["Savannah Fischer"]
  spec.email         = ["savannah.fischer@hey.com"]

  spec.summary       = %q{A ruby interface for S.E.C. 13F Data.}

  spec.description   = %q{thirteen_f lets you easily search and retrieve SEC 13F
  filing data. The SEC is the U.S. Securities and Exchange Commission. 13F
  filings are disclosures large institutional investors in public securites have
  to provide and make public every quarter. It is a great way to follow what
  different investors have been doing in US regulated equity markets.}
  spec.homepage      = "https://github.com/savfischer/thirteen_f"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 3.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/savfischer/thirteen_f"
  spec.metadata["changelog_uri"] = "https://github.com/savfischer/thirteen_f/commits/master"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "minitest"
  spec.add_development_dependency "pry"

  spec.add_runtime_dependency "http", ">= 5.1"
  spec.add_runtime_dependency "nokogiri", ">= 1.15"
  spec.add_runtime_dependency "pdf-reader", ">= 2.11"
end
