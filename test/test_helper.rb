ENV['RAILS_ENV'] = 'test'
ENV['RAILS_ROOT'] ||= File.dirname(__FILE__) + "/../../../.."

require 'rubygems'
require 'active_support'
require 'active_support/test_case'
require 'test/unit'
require 'mocha'

require File.expand_path(File.join(ENV['RAILS_ROOT'], 'config/environment.rb'))
require File.dirname(__FILE__) + '/../lib/resource_proxy' unless defined?(ResourceProxy)