require 'test_helper'

class UpdateVideoStatusJobTest < ActiveSupport::TestCase
  def test_perform__downloaded_but_does_not_exist
    v = create_video(downloaded: true)

    UpdateVideosStatusJob.perform_now

    refute_predicate v.reload, :downloaded?
  end

  def test_perform__exists_and_shceduled
    v = create_video(downloaded: false, to_download: true)
    Video.any_instance.expects(:exists?).returns(true)

    UpdateVideosStatusJob.perform_now

    assert_predicate v.reload, :downloaded?
    refute_predicate v.reload, :to_download?
  end

  def test_perform__keeps_only_recent
    Video.any_instance.stubs(:exists?).returns(true)
    File.stubs(:delete)

    s = create_subscription(keep_count: 3)
    a = create_video(downloaded: true, published_at: Time.now - 1.day,to_download: false, subscription: s)
    b = create_video(downloaded: true, published_at: Time.now - 2.day,to_download: false, subscription: s)
    c = create_video(downloaded: true, published_at: Time.now - 3.day,to_download: false, subscription: s)
    d = create_video(downloaded: true, published_at: Time.now - 4.day,to_download: false, subscription: s)

    UpdateVideosStatusJob.perform_now

    assert_predicate a.reload, :downloaded?
    assert_predicate b.reload, :downloaded?
    assert_predicate c.reload, :downloaded?
    refute_predicate d.reload, :downloaded?
  end

  def test_perform__keeps_only_recent_all
    Video.any_instance.stubs(:exists?).returns(true)
    File.stubs(:delete)

    s = create_subscription(keep_count: 4)
    a = create_video(downloaded: true, published_at: Time.now - 1.day,to_download: false, subscription: s)
    b = create_video(downloaded: true, published_at: Time.now - 2.day,to_download: false, subscription: s)
    c = create_video(downloaded: true, published_at: Time.now - 3.day,to_download: false, subscription: s)
    d = create_video(downloaded: true, published_at: Time.now - 4.day,to_download: false, subscription: s)

    UpdateVideosStatusJob.perform_now

    assert_predicate a.reload, :downloaded?
    assert_predicate b.reload, :downloaded?
    assert_predicate c.reload, :downloaded?
    assert_predicate d.reload, :downloaded?
  end
end
