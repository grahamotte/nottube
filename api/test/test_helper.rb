ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'webmock/minitest'
require 'mocha/minitest'

WebMock.disable_net_connect!

class UnitTest < ActiveSupport::TestCase
  def assert_hashes_mostly_equal(eh, ah, ignore_values_for: [])
    assert_equal eh.keys.sort, ah.keys.sort
    assert_equal eh.except(*ignore_values_for), ah.except(*ignore_values_for)
  end
end
