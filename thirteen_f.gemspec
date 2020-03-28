require_relative 'lib/thirteen_f/version'

Gem::Specification.new do |spec|
  spec.name          = "thirteen_f"
  spec.version       = ThirteenF::VERSION
  spec.authors       = ["fordfischer"]
  spec.email         = ["fordfischer07@gmail.com"]

  spec.summary       = %q{thirteen_f lets you easily interact with SEC 13-F
  filing data in all the ways we think normal human beings might want to. The
  SEC is the U.S. Securities and Exchange Commission. 13-F filings are
  disclosures large investors in public securites have to provide and make
  public every quarter.}

  spec.description   = %q{thirteen_f lets you easily interact with SEC 13-F
  filing data in all the ways we think normal human beings might want to. The
  SEC is the U.S. Securities and Exchange Commission. 13-F filings are
  disclosures large investors in public securites have to provide and make
  public every quarter.}
  spec.homepage      = "https://github.com/fordfischer/thirteen_f"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.5.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/fordfischer/thirteen_f"
  spec.metadata["changelog_uri"] = "https://github.com/fordfischer/thirteen_f/commits/master"

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
  spec.add_dependency "http", ">= 4.4"
  spec.add_dependency "nokogiri"
end
