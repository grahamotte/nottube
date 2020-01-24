require 'test_helper'

class VideoTest < ActiveSupport::TestCase
  setup :stub_all_yt

  def test_file_name
    assert_equal 'file.name', create_video.file_name
    assert_equal "SUPER - BEST VIDEO - 1.mp4", create_video(file_name: nil, video_id: 1).file_name
  end

  def test_videos_dir
    assert_equal '/mnt/lolvids', create_video.videos_dir
    assert_equal '/mnt/lolvids/file.name', create_video.path
  end

  def test_exists_eh
    refute_predicate create_video, :exists?
  end

  def test_download__not_scheduled
    assert_nil create_video.download!
  end

  def test_download__downloaded
    assert_nil create_video(downloaded: true).download!
  end

  def test_download
    v = create_video(downloaded: false, to_download: true, video_id: 'abcd1234')

    FileUtils.expects(:mkdir_p).with('/mnt/lolvids')
    Video.any_instance.expects(:system).with("youtube-dl abcd1234 -o \"/mnt/lolvids/SUPER - BEST VIDEO - abcd1234.mp4\" --write-thumbnail")

    assert_not_nil v.download!

    assert_equal "SUPER - BEST VIDEO - abcd1234.mp4", v.reload.file_name
    assert_predicate v.reload, :downloaded?
    refute_predicate v.reload, :to_download?
  end

  def test_remove
    v = create_video(downloaded: true, to_download: false, video_id: 'abcd1234')
    v.expects(:exists?).returns(true)
    File.expects(:delete).with('/mnt/lolvids/file.name')

    v.remove!

    refute_predicate v.reload, :downloaded?
    refute_predicate v.reload, :to_download?
    assert_nil v.reload.attributes.dig("file_name")
  end
end
