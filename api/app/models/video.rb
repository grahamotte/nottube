# == Schema Information
#
# Table name: videos
#
#  id              :integer          not null, primary key
#  subscription_id :integer
#  video_id        :string
#  published_at    :datetime
#  video_title     :string
#  thumbnail_url   :string
#  description     :text
#  duration        :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Video < ApplicationRecord
  belongs_to :subscription

  default_scope { order('published_at desc') }

  def yt_video
    @yt_video ||= Yt::Video.new(id: video_id)
  end

  def refresh_metadata(vid = nil)
    @yt_video = vid if vid

    update!(
      published_at: yt_video.published_at,
      title: yt_video.title,
      thumbnail_url: yt_video.thumbnail_url(:high),
      description: yt_video.description,
      duration: yt_video.duration,
    )
  end
end
