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
  spec.homepage      = "TODO: Put your gem's website or public repo URL here."
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "minitest"
end
