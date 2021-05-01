require_relative 'lib/postgrest/version'

Gem::Specification.new do |spec|
  spec.name          = "postgrest"
  spec.version       = Postgrest::VERSION
  spec.authors       = ["Marcelo Barreto"]
  spec.email         = ["marcelobarretojunior@gmail.com"]

  spec.summary       = "Ruby client for PostgREST"
  spec.description   = "Ruby client for PostgREST"
  spec.homepage      = "https://github.com/marcelobarreto/postgrest-rb"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/marcelobarreto/postgrest-rb"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "pry"
end
