require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

require 'simplecov'
SimpleCov.start

require 'ostruct'
require 'active_support/all'
require 'pry'
require 'timecop'
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require_relative '../lib/subscription'
require_relative '../lib/frequency'
require_relative '../lib/currency'
require_relative '../lib/errors'
require_relative '../lib/failure'
