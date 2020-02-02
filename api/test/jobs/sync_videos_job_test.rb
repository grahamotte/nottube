require 'test_helper'

class SyncVideosJobTest < ActiveSupport::TestCase
  def test_perform__finds_or_creates_videos
    Subscription.any_instance.expects(:yt_videos).returns(
      [
        stub(id: 'cud'),
        stub(id: 'mud'),
        stub(id: 'fud'),
      ]
    )

    assert_difference 'Video.count', 3 do
      SyncVideosJob.perform_now(create_subscription.id)
    end
  end

  def test_perform__enqueues_job_for_undownloaded
    s = create_subscription(keep_count: 2)
    a = create_video(subscription: s, published_at: Time.now - 1.day, downloaded: true)
    b = create_video(subscription: s, published_at: Time.now - 2.day)
    c = create_video(subscription: s, published_at: Time.now - 3.day)
    d = create_video(subscription: s, published_at: Time.now - 4.day)

    Video.any_instance.stubs(:file_exists?).returns(:true)
    DownloadVideoJob.expects(:perform_later).twice

    SyncVideosJob.perform_now(s.id)
  end

  def test_perform__removes_not_marked_to_keep
    s = create_subscription(keep_count: 2)
    a = create_video(subscription: s, published_at: Time.now - 1.day)
    b = create_video(subscription: s, published_at: Time.now - 2.day)
    c = create_video(subscription: s, published_at: Time.now - 3.day)
    d = create_video(subscription: s, published_at: Time.now - 4.day)

    Video.any_instance.expects(:remove!).twice

    SyncVideosJob.perform_now(s.id)
  end
end
