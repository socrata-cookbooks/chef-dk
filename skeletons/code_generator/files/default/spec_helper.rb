# frozen_string_literal: true

require 'chefspec'
require 'chefspec/berkshelf'
require 'simplecov'
require 'simplecov-console'

RSpec.configure do |c|
  c.add_setting :supported_platforms, default: {
    ubuntu: %w[18.04 16.04 14.04]
  }
end

SimpleCov.formatter = SimpleCov::Formatter::Console
SimpleCov.minimum_coverage(100)
SimpleCov.start
