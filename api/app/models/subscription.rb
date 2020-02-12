# == Schema Information
#
# Table name: subscriptions
#
#  id               :bigint           not null, primary key
#  remote_id        :string
#  url              :string           not null
#  title            :string
#  thumbnail_url    :string
#  description      :text
#  video_count      :integer
#  subscriber_count :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  type             :string           default("YtSubscription")
#

class Subscription < ApplicationRecord
  has_many :videos

  after_commit do
    ActionCable.server.broadcast('subscriptions', serialize)
  end

  def serialize
    attributes.merge(
      videos_known: videos.count,
      videos_downloaded: videos.count(&:file_exists?),
      videos_scheduled: videos.count(&:scheduled?),
      source: friendly_name,
      syncing: (
        Delayed::Job
          .all
          .map { |j| j.payload_object.job_data }
          .select { |j| j.dig('job_class') == 'SyncJob' }
          .any? { |j| j.dig('arguments').include?(id) }
      ),
    )
  end

  def videos_to_keep
    videos.first(Setting.instance.keep_count)
  end

  def friendly_name
    raise 'implement me'
  end

  def refresh_metadata
    raise 'implement me'
  end

  def remote_video_ids
    raise 'implement me'
  end

  def configure_for_me
    raise 'implement me'
  end

  def video_class
    raise 'implement me'
  end
end
