$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__)) + '/lib/'
require 'fission-app-kitchen/version'
Gem::Specification.new do |s|
  s.name = 'fission-app-kitchen'
  s.version = FissionApp::Kitchen::VERSION.version
  s.summary = 'Fission App Kitchen'
  s.author = 'Heavywater'
  s.email = 'fission@hw-ops.com'
  s.homepage = 'http://github.com/hw-product/fission-app-kitchen'
  s.description = 'Fission kitchen'
  s.require_path = 'lib'
  s.add_dependency 'fission-app'
  s.add_dependency 'fission-app-jobs'
  s.files = Dir['{lib,app,config}/**/**/*'] + %w(fission-app-kitchen.gemspec README.md CHANGELOG.md)
end
