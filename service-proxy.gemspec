$:.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'service/proxy/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = 'service-proxy'
  spec.version     = Service::Proxy::VERSION
  spec.authors     = ['Donald Piret']
  spec.email       = ['dpiret@sephora.sg']
  spec.homepage    = 'https://github.com/sephora-asia/service-proxy'
  spec.summary     = 'Easily proxy paths in your rails application to other backend services.'
  spec.description = 'Easily proxy paths in your rails application to other backend services.'
  spec.license     = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  spec.add_dependency 'rails', '>= 5.2.3'
  spec.add_dependency 'rack-proxy', '~> 0.6.5'

  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'sqlite3'
end
