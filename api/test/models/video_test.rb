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
#  file_path       :string
#  description     :text
#  duration        :integer
#  downloaded      :boolean          default(FALSE), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'test_helper'

class VideoTest < ActiveSupport::TestCase
  def test_videos_dir
    assert_equal Rails.root.join('videos').to_s, Video.new.videos_dir

    set_setting(videos_path: '/test/')
    assert_equal '/test/', Video.new.videos_dir
  end

  def test_file_path
    File.stubs(:exists?).with('/vids/file.name').returns(true)
    assert_equal '/vids/file.name', create_video(file_path: '/vids/file.name').file_path

    set_setting(videos_path: '/test/')
    File.stubs(:exists?).with("/test/SUPER - BEST VIDEO - 1.mp4").returns(true)
    assert_equal "/test/SUPER - BEST VIDEO - 1.mp4", create_video(video_id: 1).file_path
  end

  def test_download__not_scheduled
    Video.any_instance.stubs(:file_exists?).returns(true)

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
    Video.any_instance.unstub(:system)
    File.stubs(:exists?).returns(true)
    FileUtils.unstub(:mkdir_p)
    FileUtils.expects(:mkdir_p).with(Rails.root.join('videos').to_s)
    Video
      .any_instance
      .expects(:system)
      .with("youtube-dl abcd1234 -o \"SUPER - BEST VIDEO - abcd1234.mp4\" --write-thumbnail")

    v = create_video(downloaded: false, video_id: 'abcd1234')

    assert_not_nil v.download!

    assert_equal Rails.root.join('videos', "SUPER - BEST VIDEO - abcd1234.mp4").to_s, v.reload.file_path
    assert_predicate v.reload, :downloaded?
    assert_predicate v.reload, :watchable?
  end

  def test_remove
    File.unstub(:delete)
    File.unstub(:exists?)
    File.stubs(:exists?).returns(true)
    File.expects(:delete).with('/test/file.name')

    v = create_video(file_path: '/test/file.name', downloaded: true, video_id: 'abcd1234')

    v.remove!

    refute_predicate v.reload, :downloaded?
    assert_nil v.reload.attributes.dig("file_path")
  end

  def test_scheduled
    s = create_subscription(keep_count: 1)
    a = create_video(subscription: s, published_at: Time.now - 1.day)
    b = create_video(subscription: s, published_at: Time.now - 2.day)

    assert_predicate a, :scheduled?
    refute_predicate b, :scheduled?
  end
end
