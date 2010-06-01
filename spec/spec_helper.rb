$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rubygems'
# Set up gems listed in the Gemfile.
require 'bundler'
Bundler.setup
Bundler.require

require 'resource_defaults'
require 'rspec'
require 'rspec/autorun'
