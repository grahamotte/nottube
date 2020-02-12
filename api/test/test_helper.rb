ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'webmock/minitest'
require 'mocha/minitest'

WebMock.disable_net_connect!

class ActiveSupport::TestCase
  parallelize(workers: :number_of_processors)
  fixtures :all

  setup do
    FileUtils.stubs(:mkdir_p)
    File.stubs(:delete)
    File.stubs(:exists?).returns(true)
    Video.any_instance.stubs(:system)
  end

  def set_setting(attrs)
    s = Setting.instance
    s.assign_attributes(attrs)
    s.save(validate: false)
  end

  def create_subscription(attrs = {})
    Subscription.create!(
      attrs.reverse_merge(
        url: "http://goog.co/#{SecureRandom.hex}",
        remote_id: SecureRandom.hex,
        title: "SUPER",
        video_count: 123,
        thumbnail_url: "http://thumb.co/thumby.png",
        description: 'this is literally the best video ever',
        subscriber_count: 213000,
      )
    )
  end

  def create_video(attrs = {})
    Video.create!(
      attrs.reverse_merge(
        subscription: create_subscription,
        title: "BEST VIDEO",
        remote_id: SecureRandom.hex,
        thumbnail_url: "http://thumb.co/thumby2.png",
        description: 'just a vid yo',
        duration: 10101,
        downloaded: false,
      )
    )
  end
end
