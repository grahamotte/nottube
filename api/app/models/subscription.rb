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
#  keep             :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  keep_count       :integer          default(10), not null
#  look_back_count  :integer          default(100), not null
#

class Subscription < ApplicationRecord
  has_many :videos

  def yt_channel
    @yt_channel ||= Yt::Channel.new(id: channel_id)
  end

  def yt_videos
    yt_channel.videos
  end

  def refresh_metadata
    update!(channel_id: Yt::URL.new(url).id) if channel_id.blank?

    update!(
      title: yt_channel.title,
      video_count: yt_channel.video_count,
      thumbnail_url: yt_channel.thumbnail_url,
      description: yt_channel.description,
      subscriber_count: yt_channel.subscriber_count,
    )
  end
end
