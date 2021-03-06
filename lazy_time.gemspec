# frozen_string_literal: true

require_relative "lib/lazy_time/version"

Gem::Specification.new do |spec|
  spec.name = "lazy_time"
  spec.version = LazyTime::VERSION
  spec.authors = ["Mathias Karstädt"]
  spec.email = ["mathias.karstaedt@gmail.com"]

  spec.summary = "A tool to track your working hours"
  spec.description = "A tool to track your working hours"
  spec.homepage = "https://webmatze.de"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  # spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  # spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "thor", "~> 1.2.1"
  spec.add_dependency "toml", "~> 0.3.0"
  spec.add_dependency "tty-config", "~> 0.5.1"
  spec.add_dependency "tty-cursor", "~> 0.7.1"
  spec.add_dependency "tty-editor", "~> 0.7.0"
  spec.add_dependency "tty-font", "~> 0.5.0"
  spec.add_dependency "tty-prompt", "~> 0.23.1"
  spec.add_dependency "tty-screen", "~> 0.8.1"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
