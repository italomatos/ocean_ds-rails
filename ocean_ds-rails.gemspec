require_relative "lib/ocean_ds/version"

Gem::Specification.new do |spec|
  spec.name        = "ocean_ds-rails"
  spec.version     = OceanDS::Rails::VERSION
  spec.authors     = ["BLU"]
  spec.email       = ["opensource@useblu.com.br"]

  spec.summary     = "Ocean DS (Blu's Design System) para o asset pipeline do Rails."
  spec.description = "Empacota o CSS, os tokens SCSS e as fontes do Ocean DS " \
                     "(@useblu/ocean-core + @useblu/ocean-tokens) e os pluga no " \
                     "asset pipeline do Rails (Propshaft e Sprockets)."
  spec.homepage    = "https://github.com/ocean-ds"
  spec.license     = "GPL-3.0"

  spec.metadata["homepage_uri"]    = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/ocean-ds"

  spec.files = Dir[
    "lib/**/*",
    "app/assets/**/*",
    "vendor/assets/**/*",
    "LICENSE",
    "README.md"
  ]
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.7"

  spec.add_dependency "railties", ">= 6.0"

  spec.add_development_dependency "rake", ">= 13.0"
end
