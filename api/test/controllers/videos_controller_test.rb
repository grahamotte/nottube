# frozen_string_literal: true

require 'test_helper'

class VideosControllerTest < ActionController::TestCase
  def test_videos
    time = Time.at(123111231)

    s = create_subscription(keep_count: 1)
    a = create_video(video_id: 'a1', subscription: s, published_at: time - 1.day)
    b = create_video(video_id: 'a2', subscription: s, published_at: time - 2.day)
    c = create_video(video_id: 'a3', subscription: s, published_at: time - 3.day)

    Video.any_instance.stubs(:created_at).returns(time)
    Video.any_instance.stubs(:updated_at).returns(time)

    get :index, params: { subscription_id: s.id }

    expected = [
      {
        'id' => a.id,
        'subscription_id' => s.id,
        'video_id' => 'a1',
        'published_at' => '1973-11-24T21:33:51.000Z',
        'title' => 'BEST VIDEO',
        'thumbnail_url' => 'http://thumb.co/thumby2.png',
        'file_name' => 'file.name',
        'description' => 'just a vid yo',
        'duration' => 10_101,
        'downloaded' => false,
        'created_at' => '1973-11-25T13:33:51.000-08:00',
        'updated_at' => '1973-11-25T13:33:51.000-08:00'
      },
      {
        'id' => b.id,
        'subscription_id' => s.id,
        'video_id' => 'a2',
        'published_at' => '1973-11-23T21:33:51.000Z',
        'title' => 'BEST VIDEO',
        'thumbnail_url' => 'http://thumb.co/thumby2.png',
        'file_name' => 'file.name',
        'description' => 'just a vid yo',
        'duration' => 10_101,
        'downloaded' => false,
        'created_at' => '1973-11-25T13:33:51.000-08:00',
        'updated_at' => '1973-11-25T13:33:51.000-08:00'
      },
      {
        'id' => c.id,
        'subscription_id' => s.id,
        'video_id' => 'a3',
        'published_at' => '1973-11-22T21:33:51.000Z',
        'title' => 'BEST VIDEO',
        'thumbnail_url' => 'http://thumb.co/thumby2.png',
        'file_name' => 'file.name',
        'description' => 'just a vid yo',
        'duration' => 10_101,
        'downloaded' => false,
        'created_at' => '1973-11-25T13:33:51.000-08:00',
        'updated_at' => '1973-11-25T13:33:51.000-08:00'
      }
    ]

    assert_equal expected, JSON.parse(response.body)
  end
end
