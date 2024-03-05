# typed: false
# frozen_string_literal: true

require_relative "lib/vigiles/version"

Gem::Specification.new do |spec|
  spec.name = "vigiles"
  spec.version = Vigiles::VERSION
  spec.authors = ["Yaw Boakye"]
  spec.email = ["wheresyaw@gmail.com"]

  spec.summary = "vigiles stand at the gates of your walled city and records all the in/outflows."
  spec.description = spec.summary
  spec.homepage = "https://github.com/yawboakye/vigiles"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = %(#{spec.homepage}/CHANGELOG.md)

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ features/ .git .github appveyor Gemfile])
    end
  end

  spec.require_paths = %(lib)

  spec.add_runtime_dependency     "sorbet-runtime",   "~> 0.5"

  spec.add_development_dependency "debug",            "~> 1.9"
  spec.add_development_dependency "minitest",         "~> 5.16"
  spec.add_development_dependency "rake",             "~> 13.0"
  spec.add_development_dependency "rubocop",          "~> 1.21"
  spec.add_development_dependency "rubocop-minitest", "~> 0.34"
  spec.add_development_dependency "rubocop-rake",     "~> 0.6"
  spec.add_development_dependency "rubocop-sorbet",   "~> 0.7"
  spec.add_development_dependency "sorbet",           "~> 0.5"
  spec.add_development_dependency "spoom",            "~> 1.2"
  spec.add_development_dependency "tapioca",          "~> 0.12"

  spec.add_dependency "rails",                        "~> 7.0"
  spec.add_dependency "zeitwerk",                     "~> 2.6"
end
