# == Schema Information
#
# Table name: videos
#
#  id              :integer          not null, primary key
#  subscription_id :integer
#  video_id        :string
#  published_at    :datetime
#  title           :string
#  thumbnail_url   :string
#  file_name       :string
#  description     :text
#  duration        :integer
#  downloaded      :boolean          default(FALSE), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'test_helper'

class VideoTest < ActiveSupport::TestCase
  def test_file_name
    assert_equal 'file.name', create_video.file_name
    assert_equal "SUPER - BEST VIDEO - 1.mp4", create_video(file_name: nil, video_id: 1).file_name
  end

  def test_videos_dir
    assert_equal '/mnt/lolvids', create_video.videos_dir
    assert_equal '/mnt/lolvids/file.name', create_video.path
  end

  def test_download__not_scheduled
    s = create_subscription(keep_count: 1)
    a = create_video(subscription: s, published_at: Time.now - 1.day)
    b = create_video(subscription: s, published_at: Time.now - 2.day)
    c = create_video(subscription: s, published_at: Time.now - 3.day)

    assert_predicate a, :download!
    refute_predicate b, :download!
    refute_predicate c, :download!
  end

  def test_download__downloaded
    refute_predicate create_video(downloaded: true), :download!
  end

  def test_download
    v = create_video(downloaded: false, video_id: 'abcd1234')

    FileUtils.expects(:mkdir_p).with('/mnt/lolvids')
    Video.any_instance.expects(:system).with("youtube-dl abcd1234 -o \"/mnt/lolvids/SUPER - BEST VIDEO - abcd1234.mp4\" --write-thumbnail")

    assert_not_nil v.download!

    assert_equal "SUPER - BEST VIDEO - abcd1234.mp4", v.reload.file_name
    assert_predicate v.reload, :downloaded?
  end

  def test_remove
    v = create_video(downloaded: true, video_id: 'abcd1234')
    v.expects(:file_exists?).returns(true)
    File.expects(:delete).with('/mnt/lolvids/file.name')

    v.remove!

    refute_predicate v.reload, :downloaded?
    assert_nil v.reload.attributes.dig("file_name")
  end

  def test_scheduled
    s = create_subscription(keep_count: 1)
    a = create_video(subscription: s, published_at: Time.now - 1.day)
    b = create_video(subscription: s, published_at: Time.now - 2.day)

    assert_predicate a, :scheduled?
    refute_predicate b, :scheduled?
  end
end
