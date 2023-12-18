# frozen_string_literal: true

require_relative "lib/resorcery/version"

Gem::Specification.new do |spec|
  spec.name = "resorcery"
  spec.version = Resorcery::VERSION
  spec.authors = ["Philip Kirkham"]
  spec.email = ["pkirkham@antrimcreek.com"]

  spec.summary = "Fast, powerful, flexible scaffolding for Rails"
  spec.description = "Fast, powerful, flexible scaffolding for Rails"
  spec.homepage = "https://github.com/antrimcreek/resorcery"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.0"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rails", ">= 7.0.0"

  spec.add_dependency "importmap-rails"
  spec.add_dependency "sassc", "~> 2.0", "< 2.4"
  spec.add_dependency "turbo-rails"
  spec.add_dependency "view_component", ">= 3.0.0"

  spec.add_dependency "ransack", ">= 4.0.0"
  spec.add_dependency "simple_form_ransack", ">= 0.0.21"

  spec.add_dependency "kaminari", ">= 1.2"

  spec.add_dependency "commonmarker", "~> 0.23.9"
  spec.add_dependency "github-markup", "~> 4.0"
end
