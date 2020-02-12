# == Schema Information
#
# Table name: subscriptions
#
#  id               :integer          not null, primary key
#  remote_id        :string
#  url              :string           not null
#  title            :string
#  thumbnail_url    :string
#  description      :text
#  video_count      :integer
#  subscriber_count :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  keep_count       :integer          default(8), not null
#  type             :string
#

class YtSubscription < Subscription
  validates :remote_id, uniqueness: true

  before_validation do
    self.remote_id ||= hash_find(channel_info, :channelId)
  end

  def configure_for_me
    nil
  end

  def friendly_name
    'YouTube'
  end

  def video_class
    YtVideo
  end

  def remote_video_ids(n)
    remote_videos(n).map { |x| x.dig(:id) }
  end

  def refresh_metadata
    update!(
      title: hash_find_dig(channel_info, :metadata, :title),
      video_count: -1,
      thumbnail_url: hash_find_dig(channel_info, :metadata, :avatar, :thumbnails, :url),
      description: hash_find_dig(channel_info, :metadata, :description),
      subscriber_count: -1,
    )
  end

  def channel_info
    @channel_info ||= aggressive_deep_symbolize_keys(
      JSON.parse(
        RestClient::Request.execute(
          method: :get,
          url: url,
          headers: {
            params: { pbj: 1 },
            'X-YouTube-Client-Version' => '2.20200211.02.00',
            'X-YouTube-Client-Name' => 1,
          }
        ).body
      )
    ).sort_by { |x| x.keys.length }.last
  end

  def remote_videos(n)
    execute('youtube-dl', '-j', "--playlist-end=#{n}", url)
      .split("\n")
      .map { |x| JSON.parse(x).deep_symbolize_keys }
  end
end
