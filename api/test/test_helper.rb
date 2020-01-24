ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'webmock/minitest'
require 'mocha/minitest'

class ActiveSupport::TestCase
  parallelize(workers: :number_of_processors)
  fixtures :all

  setup do
    ENV['PLEXTUBE_VIDEO_DIR'] = '/mnt/lolvids'
  end

  def stub_all_yt
    stub_yt_url_req
  end

  def stub_yt_url_req(ret = -1)
    Yt::URL.stubs(:new).returns(stub(id: ret))
  end

  def create_subscription(attrs = {})
    Subscription.create!(
      attrs.reverse_merge(
        url: "http://goog.co/#{SecureRandom.hex}",
        channel_id: SecureRandom.hex,
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
        video_id: SecureRandom.hex,
        thumbnail_url: "http://thumb.co/thumby2.png",
        file_name: 'file.name',
        description: 'just a vid yo',
        duration: 10101,
        to_download: false,
        downloaded: false,
      )
    )
  end
end
