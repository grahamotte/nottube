# == Schema Information
#
# Table name: subscriptions
#
#  id               :integer          not null, primary key
#  channel_id       :string
#  url              :string           not null
#  title            :string
#  thumbnail_url    :string
#  description      :text
#  video_count      :integer
#  subscriber_count :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  keep_count       :integer          default(8), not null
#

class YtSubscription < Subscription
  validates :channel_id, uniqueness: true

  before_validation do
    self.channel_id ||= Yt::URL.new(url).id
  end

  def remote_videos
    Yt::Channel.new(id: channel_id).videos
  end

  def refresh_metadata
    update!(channel_id: Yt::URL.new(url).id) if channel_id.blank?

    update!(
      title: yt_channel.title || yt_channel.content_owner,
      video_count: yt_channel.video_count,
      thumbnail_url: yt_channel.thumbnail_url,
      description: yt_channel.description,
      subscriber_count: yt_channel.subscriber_count,
    )
  end
end
