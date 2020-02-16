require 'test_helper'

class VideoTest < UnitTest
  class DummyVideo < Video
    def execute_download
      update_attribute(:file_path, "/opt/videos/vid.mp4")
    end
  end

  def test_serialize
    assert_hashes_mostly_equal(
      (
        {
          id: 12,
          subscription_id: 2,
          remote_id: "aabbcc",
          published_at: Time.at(1581863290).to_datetime,
          title: "sharpest chocolate kitchen knife in the world",
          thumbnail_url: "https://i.ytimg.com/vi/D2XNVFlh-DU/hqdefault.jpg?sqp=-oaymwEZCNACELwBSFXyq4qpAwsIARUAAIhCGAFwAQ==&rs=AOn4CLBz1P9wTHBytoE_2oL1Xu64z8MMsA",
          file_path: nil,
          description: (
            <<~TEXT
              sharpest chocolate kitchen knife in the world
              ---
              Q, Is this a serial killer channel?
              A, Materials Science channel
              Normal person: “Hm, chocolate. I should make some candy.”
              Kawami: “Hm, chocolate. How many ways can I make to cut something with this?”
            TEXT
          ),
          duration: 12345,
          created_at: 'Sun, 16 Feb 2020 15:02:32 UTC +00:00',
          updated_at: 'Sun, 16 Feb 2020 15:02:32 UTC +00:00',
          type: "YtVideo",
          scheduled: false,
          downloaded: false,
        }
      ),
      Fabricate(:video).serialize,
      ignore_values_for: [:updated_at, :created_at, :id, :subscription_id, :remote_id],
    )
  end

  def test_scheduled
    s = Fabricate(:setting)
    sub = Fabricate(:subscription)

    sub.videos.shuffle.each.with_index do |v, i|
      v.update!(published_at: Time.now - i.days)
    end

    assert_predicate sub.reload.videos[0], :scheduled?
    assert_predicate sub.reload.videos[1], :scheduled?
    assert_predicate sub.reload.videos[2], :scheduled?
    refute_predicate sub.reload.videos[3], :scheduled?
    refute_predicate sub.reload.videos[4], :scheduled?
  end

  def test_file_exists
    v = Fabricate(:video)
    refute_predicate v, :file_exists?

    File.stubs(:exists?).with("/opt/videos/#{v.send(:derived_title)}.mp4").returns(true)
    assert_predicate v, :file_exists?

    v.update!(file_path: '/opt/videos/vid.avi')
    File.stubs(:exists?).with('/opt/videos/vid.avi').returns(true)
    assert_predicate v, :file_exists?
  end

  def test_refresh_metadata
    assert_raises { Fabricate(:video).refresh_metadata! }
  end
end
