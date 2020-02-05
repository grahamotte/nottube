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
    self.remote_id ||= Yt::URL.new(url).id
  end

  def configure_for_me
    Yt.configure { |c| c.api_key = Setting.instance.yt_api_keys.sample }
  end

  def friendly_name
    'YouTube'
  end

  def video_class
    YtVideo
  end


  def remote_video_ids
    Yt::Channel.new(id: remote_id).videos.map(&:id)
  end

  def refresh_metadata
    yt_channel = Yt::Channel.new(id: remote_id)

    update!(remote_id: Yt::URL.new(url).id) if remote_id.blank?

    update!(
      title: yt_channel.title || yt_channel.content_owner,
      video_count: yt_channel.video_count,
      thumbnail_url: yt_channel.thumbnail_url,
      description: yt_channel.description,
      subscriber_count: yt_channel.subscriber_count,
    )
  end
end
