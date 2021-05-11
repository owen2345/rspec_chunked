$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "rspec_chunked/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = 'rspec_chunked'
  spec.version     = RspecChunked::VERSION
  spec.authors     = ['owen2345']
  spec.email       = ['owenperedo@gmail.com']
  spec.homepage    = 'https://github.com/owen2345/rspec_chunked'
  spec.summary     = 'Run chunked rspec tests on specific qty, sample: CI_JOBS=3 CI_JOB=1 rake rspec_chunked'
  spec.description = 'Run chunked rspec tests on specific qty, sample: CI_JOBS=3 CI_JOB=1 rake rspec_chunked'
  spec.license     = 'MIT'

  spec.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
  spec.add_dependency 'rails', '>= 4.0'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
end
